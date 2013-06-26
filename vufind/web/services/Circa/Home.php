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

require_once 'Action.php';
require_once('services/Admin/Admin.php');

class Home extends Action
{
	function launch()
	{
		global $configArray;
		global $interface;

		if (isset($_POST['submit'])){
			$results = $this->processInventory();
			$interface->assign('results', $results);
		}

		//Get view & load template
		$interface->setTemplate('home.tpl');
		$interface->display('layout.tpl', 'Circa');
	}

	function processInventory(){
		global $configArray;
		global $interface;
		$login = $_REQUEST['login'];
		$interface->assign('lastLogin', $login);
		$password1 = $_REQUEST['password1'];
		$interface->assign('lastPassword1', $password1);
		$initials = $_REQUEST['initials'];
		$interface->assign('lastInitials', $initials);
		$password2 = $_REQUEST['password2'];
		$interface->assign('lastPassword2', $password2);
		$barcodes = $_REQUEST['barcodes'];
		$updateIncorrectStatuses = isset($_REQUEST['updateIncorrectStatuses']);
		$interface->assign('lastUpdateIncorrectStatuses', $updateIncorrectStatuses);

		try {
			$catalog = new CatalogConnection($configArray['Catalog']['driver']);
		} catch (PDOException $e) {
			// What should we do with this error?
			if ($configArray['System']['debug']) {
				echo '<pre>';
				echo 'DEBUG: ' . $e->getMessage();
				echo '</pre>';
			}
		}

		$results = $catalog->doInventory($login, $password1, $initials, $password2, $barcodes, $updateIncorrectStatuses);
		return $results;
	}

	function getAllowableRoles(){
		return array('opacAdmin', 'libraryAdmin');
	}
}
?>