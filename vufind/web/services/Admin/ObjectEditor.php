<?php
/**
 *
 * Copyright (C) Villanova University 2007.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2,
 * as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 */

require_once ROOT_DIR . '/Action.php';
require_once ROOT_DIR . '/services/Admin/Admin.php';
require_once 'XML/Unserializer.php';

abstract class ObjectEditor extends Admin_Admin
{
	function launch()
	{
		global $interface;

		$interface->assign('canAddNew', $this->canAddNew());
		$interface->assign('canDelete', $this->canDelete());
		$interface->assign('showReturnToList', $this->showReturnToList());
		$interface->assign('showExportAndCompare', $this->showExportAndCompare());

		$interface->assign('objectType', $this->getObjectType());
		$interface->assign('toolName', $this->getToolName());

		//Define the structure of the object.
		$structure = $this->getObjectStructure();
		$interface->assign('structure', $structure);
		$objectAction = isset($_REQUEST['objectAction']) ? $_REQUEST['objectAction'] : null;
		$customListActions = $this->customListActions();
		$interface->assign('customListActions', $customListActions);
		if (is_null($objectAction) || $objectAction == 'list'){
			$this->viewExistingObjects();
		}elseif ($objectAction == 'export'){
			$this->exportObjectsToFile($structure);
			exit();
		}elseif ($objectAction == 'import' || $objectAction == 'compare'){
			$quit = $this->importOrCompareFile($objectAction, $structure);
			if ($quit){
				die();
			}
		}elseif (($objectAction == 'save' || $objectAction == 'delete') && isset($_REQUEST['id'])){
			$this->editObject($objectAction, $structure);
		}else{
			//check to see if a custom action is being called.
			if (method_exists($this, $objectAction)){
				$this->$objectAction();
			}else{
				$this->viewIndividualObject($structure);
			}
		}
		$interface->setPageTitle($this->getPageTitle());
		$interface->display('layout.tpl');

	}
	/**
	 * The class name of the object which is being edited
	 */
	abstract function getObjectType();
	/**
	 * The page name of the tool (typically the plural of the object)
	 */
	abstract function getToolName();
	/**
	 * The title of the page to be displayed
	 */
	abstract function getPageTitle();
	/**
	 * Load all objects into an array keyed by the primary key
	 */
	abstract function getAllObjects();
	/**
	 * Define the properties which are editable for the object
	 * as well as how they should be treated while editing, and a description for the property
	 */
	abstract function getObjectStructure();
	/**
	 * The name of the column which defines this as unique
	 */
	abstract function getPrimaryKeyColumn();
	/**
	 * The id of the column which serves to join other columns
	 */
	abstract function getIdKeyColumn();

	function getExistingObjectByPrimaryKey($objectType, $value){
		$primaryKeyColumn = $this->getPrimaryKeyColumn();
		/** @var DB_DataObject $curLibrary */
		$curLibrary = new $objectType();
		$curLibrary->$primaryKeyColumn = $value;
		$curLibrary->find();
		if ($curLibrary->N == 1){
			$curLibrary->fetch();
			return $curLibrary;
		}else{
			return null;
		}
	}
	function getExistingObjectById($id){
		$objectType = $this->getObjectType();
		$idColumn = $this->getIdKeyColumn();
		/** @var DB_DataObject $curLibrary */
		$curLibrary = new $objectType;
		$curLibrary->$idColumn = $id;
		$curLibrary->find();
		if ($curLibrary->N == 1){
			$curLibrary->fetch();
			return $curLibrary;
		}else{
			return null;
		}
	}

	function insertObject($structure){
		$objectType = $this->getObjectType();
		/** @var DB_DataObject $newObject */
		$newObject = new $objectType;
		//Check to see if we are getting default values from the
		$this->updateFromUI($newObject, $structure);
		$ret = $newObject->insert();
		if (!$ret){
			global $logger;
			$logger->log('Could not insert new object ' . $ret, PEAR_LOG_DEBUG);
			$logger->log(mysql_error(), PEAR_LOG_DEBUG);
			return false;
		}
		return $newObject;
	}
	function setDefaultValues($object, $structure){
		foreach ($structure as $property){
			$propertyName = $property['property'];
			if (isset($_REQUEST[$propertyName])){
				$object->$propertyName = $_REQUEST[$propertyName];
			}
		}
	}
	function updateFromUI($object, $structure){
		require_once ROOT_DIR . '/sys/DataObjectUtil.php';
		DataObjectUtil::updateFromUI($object, $structure);
	}
	function viewExistingObjects(){
		global $interface;
		//Basic List
		$interface->assign('dataList', $this->getAllObjects());
		$interface->setTemplate('../Admin/propertiesList.tpl');
	}
	function viewIndividualObject($structure){
		global $interface;
		//Viewing an individual record, get the id to show
		if (isset($_SERVER['HTTP_REFERER'])){
			$_SESSION['redirect_location'] = $_SERVER['HTTP_REFERER'];
		}else{
			unset($_SESSION['redirect_location']);
		}
		if (isset($_REQUEST['id'])){
			$id = $_REQUEST['id'];
			$existingObject = $this->getExistingObjectById($id);
			$interface->assign('id', $id);
			if (method_exists($existingObject, 'label')){
				$interface->assign('objectName', $existingObject->label());
			}
		}else{
			$existingObject = null;
		}
		if (!isset($_REQUEST['id']) || $existingObject == null){
			$objectType = $this->getObjectType();
			$existingObject = new $objectType;
			$this->setDefaultValues($existingObject, $structure);
		}
		$interface->assign('object', $existingObject);
		//Check to see if the request should be multipart/form-data
		$contentType = null;
		foreach ($structure as $property){
			if ($property['type'] == 'image' || $property['type'] == 'file'){
				$contentType = 'multipart/form-data';
			}
		}
		$interface->assign('contentType', $contentType);

		$interface->assign('additionalObjectActions', $this->getAdditionalObjectActions($existingObject));
		$interface->setTemplate('../Admin/objectEditor.tpl');
	}

	function exportObjectsToFile($structure){
		//Load all of the rows in the table
		$objects = $this->getAllObjects();

		$curDate = date('Y-m-d-H-i');

		//Output to the browser.
		header('Expires: 0');
		header('Cache-control: private');
		header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
		header('Content-Description: File Transfer');
		header('Content-Type: text/csv');
		header("Content-disposition: attachment; filename=\"{$_SERVER['SERVER_NAME']}_{$this->getObjectType()}_$curDate.csv\"");

		//Output system and date
		$curRow = array(
          'Export Of:',
		$this->getObjectType(),
          'Export From:',
		$_SERVER['SERVER_NAME'],
          'On:',
		$curDate
		);
		echo(implode(',',$curRow) . "\n");

		//Output column headers
		$curRow = array();
		$objectIdColumn = $this->getIdKeyColumn();
		$curRow[] = '"' . $objectIdColumn . '"';
		foreach($structure as $property){
			$curRow[] = '"' . $property['property'] . '"';
		}
		echo(implode(',',$curRow) . "\n");
		//Output each row
		foreach ($objects as $object){
			$curRow = array();
			$curRow[] = '"' . $object->$objectIdColumn . '"';
			foreach($structure as $property){
				$propertyName = $property['property'];
				$curRow[] = '"' . $object->$propertyName . '"';
			}
			echo( implode(',',$curRow) . "\n");
		}
	}

	/**
	 * Import objects from a file or compare the existing information in a file
	 * to the objects currently in the system.
	 */
	function importOrCompareFile($objectAction, $structure){
		global $interface;
		//Import the information from the file
		if ($_FILES['uploadedfile']['error'] > 0){
			echo "Error uploading file " . $_FILES['uploadedfile']['error'];
			die();
		}else{
			//Open the file and begin processing it.
			$filepath = $_FILES['uploadedfile']['tmp_name'];
			$handle = fopen($filepath, "r");
			$row = 1;
			$columnHeaders = null;
			$importedData = array();
			$objectType = $this->getObjectType();
			$primaryKey = $this->getPrimaryKeyColumn();
			$objectIdColumn = $this->getIdKeyColumn();
			$existingObjects = $this->getAllObjects();

			while (($data = fgetcsv($handle, 1000, ",", '"')) != FALSE){
				if ($row == 1){
					//System row
					if (count($data) < 6){
						echo "This file does not appear to have been created from VuFind.";
						die();
					}
					if ($data[1] != $this->getObjectType()){
						echo "This file was saved from a different object type.";
						die();
					}
				}else if ($row == 2){
					//Column Headers
					$columnHeaders = $data;
				}else{
					if (count($data) != count($columnHeaders)){
						echo "Invalid file, row $row did not have the same number of columns as the header.";
						die();
					}
					//Data row
					/** @var DB_DataObject $object */
					$object = new $objectType;
					$columnNumber = 0;
					foreach ($data as $cell){
						$columnName = $columnHeaders[$columnNumber];
						$object->$columnName = trim($cell);
						$columnNumber++;
					}

					//Check to see if the object is new or not
					$primaryKeyValue = $object->$primaryKey;
					$existingObject = $this->getExistingObjectByPrimaryKey($objectType, $primaryKeyValue);
					if (is_null($existingObject)){
						if ($objectAction == 'import'){
							$object->insert();
						}else{
							//Mark the record as being new.
							$object->class='objectInserted';
						}
					}else{
						if ($objectAction == 'import'){
							//set the id
							//Update the record
							$object->update();
						}else{
							//Compare the record
							$updated = false;
							foreach ($structure as $property){
								$propertyName = $property['property'];
								$oldPropertyName = $property['propertyOld'];
								$oldValue = $existingObject->$propertyName;
								$newValue = $object->$propertyName;
								if ($newValue != $oldValue){
									$updated = true;
									$object->$oldPropertyName = $oldValue;
								}
							}
							if ($updated){
								$object->class='objectUpdated';
							}
						}
					}
					//Add to the import list
					$objectId = $object->$objectIdColumn;
					$importedData[$objectId] = $object;
				}

				$row++;
			}

			//Check for any deleted objects.
			/** @var DB_DataObject $existingObject */
			foreach ($existingObjects as $key => $existingObject){
				if (!array_key_exists($key, $importedData)){
					if ($objectAction == 'import'){
						$existingObject->delete();
					}else{
						$existingObject->class = 'objectDeleted';
						$importedData[$key] = $existingObject;
					}
				}
			}

			if ($objectAction == 'import'){
				global $configArray;
				header("Location: {$configArray['Site']['path']}/Admin/{$this->getToolName()}");
				return true;
			}else{
				//Show the grid with the comparison results
				$interface->assign('dataList', $importedData);
				$interface->setTemplate('propertiesList.tpl');
				return false;
			}
		}
	}

	function editObject($objectAction, $structure){
		global $interface;
		//Save or create a new object
		$id = $_REQUEST['id'];
		if (empty($id) || $id < 0){
			//Insert a new record
			$curObject = $this->insertObject($structure);
			if ($curObject == false){
				$interface->assign('title', "An error occurred inserting new {$this->getObjectType()}");
			}
		}else{
			//Work with an existing record
			$curObject = $this->getExistingObjectById($id);
			if (!is_null($curObject)){
				if ($objectAction == 'save'){
					//Update the object
					$this->updateFromUI($curObject, $structure);
					$ret = $curObject->update();
					if ($ret == false){
						$interface->assign('title', "An error occurred updating {$this->getObjectType()} with id of $id");
					}
				}else if ($objectAction =='delete'){
					//Delete the record
					$ret = $curObject->delete();
					if ($ret == false){
						$interface->assign('title', "Unable to delete {$this->getObjectType()} with id of $id");
					}
				}
			}else{
				//Couldn't find the record.  Something went haywire.
				$interface->assign('title', "An error occurred, could not find {$this->getObjectType()} with id of $id");
			}
		}
		global $configArray;
		if (isset($_REQUEST['submitStay'])){
			header("Location: {$configArray['Site']['path']}/{$this->getModule()}/{$this->getToolName()}?objectAction=edit&id=$id");
		}elseif (isset($_REQUEST['submitAddAnother'])){
			header("Location: {$configArray['Site']['path']}/{$this->getModule()}/{$this->getToolName()}?objectAction=addNew");
		}else{
			$redirectLocation = $this->getRedirectLocation($objectAction, $curObject);
			if (is_null($redirectLocation)){
				if (isset($_SESSION['redirect_location']) && $objectAction != 'delete'){
					header("Location: " . $_SESSION['redirect_location']);
				}else{
					header("Location: {$configArray['Site']['path']}/{$this->getModule()}/{$this->getToolName()}");
				}
			}else{
				header("Location: {$redirectLocation}");
			}
		}
		die();
	}

	function getRedirectLocation($objectAction, $curObject){
		return null;
	}
	function showReturnToList(){
		return true;
	}

	function getFilters(){
		return array();
	}
	function getModule(){
		return 'Admin';
	}

	function getFilterValues(){
		$filters = $this->getFilters();
		foreach ($filters as $filter){
			if ($_REQUEST[$filter['filter']]){
				$filter['value'] = $_REQUEST[$filter['filter']];
			}else{
				$filter['value'] = '';
			}
		}
		return $filters;
	}

	public function canAddNew(){
		return true;
	}

	public function canDelete(){
		return true;
	}

	public function customListActions(){
		return array();
	}

	public function showExportAndCompare(){
		return true;
	}

	function getAdditionalObjectActions($existingObject){
		return array();
	}
}