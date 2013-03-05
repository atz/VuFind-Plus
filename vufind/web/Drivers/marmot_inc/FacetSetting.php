<?php
require_once 'DB/DataObject.php';
require_once 'DB/DataObject/Cast.php';

abstract class FacetSetting extends DB_DataObject {
	public $id;                      //int(25)
	public $displayName;                    //varchar(255)
	public $facetName;
	public $weight;
	public $numEntriesToShowByDefault; //
	public $showAsDropDown;   //True or false
	public $sortMode;         //0 = alphabetically, 1 = by number of results
	public $showAboveResults;
	public $showInResults;
	public $showInAuthorResults;
	public $showInAdvancedSearch;
	public $collapseByDefault;
	public $useMoreFacetPopup;

	public function getAvailableFacets(){
		$availableFacets = array(
			"institution" => "Library System",
			"building" => "Branch",
			"available_at" => "Available At",
			"collection_group" => "Collection",
			"collection_adams" => "Collection (ASU)",
			"collection_msc" => "Collection (CMU)",
			"collection_western" => "Collection (Western)",
			"rating_facet" => "Rating",
			"publishDate" => "Publication Year",
			"format" => "Format",
			"format_category" => "Format Category",
			"econtent_device" => "Compatible Device",
			"econtent_source" => "E-Content Collection",
			"econtent_protection_type" => "E-Content Protection",
			"topic_facet" => "Topics",
			"target_audience" => "Audience",
			"mpaa_rating" => "Movie Rating",
			"literary_form" => "Form",
			"authorStr" => "Author",
			"language" => "Language",
			"genre_facet" => "Genre",
			"era" => "Era",
			"geographic_facet" => "Region",
			"target_audience_full" => "Reading Level",
			"literary_form_full" => "Literary Form",
			"lexile_code" => "Lexile Code",
			"lexile_score" => "Lexile Score",
			"itype" => "Item Type",
			"time_since_added" => "Added In The Last",
			"callnumber-first" => "LC Call Number",
			"awards_facet" => "Awards",
			"detailed_location" => "Detailed Location",
		);
		asort($availableFacets);
		return $availableFacets;
	}

	function getObjectStructure(){
		global $user;

		$structure = array(
			'id' => array('property'=>'id', 'type'=>'label', 'label'=>'Id', 'description'=>'The unique id of this association'),
			'weight' => array('property'=>'weight', 'type'=>'integer', 'label'=>'Weight', 'description'=>'The sort order of the book store', 'default' => 0),
			'facetName' => array('property'=>'facetName', 'type'=>'enum', 'label'=>'Facet', 'values' => LibraryFacetSetting::getAvailableFacets(), 'description'=>'The facet to include'),
			'displayName' => array('property'=>'displayName', 'type'=>'text', 'label'=>'Display Name', 'description'=>'The full name of the facet for display to the user'),
			'numEntriesToShowByDefault' => array('property'=>'numEntriesToShowByDefault', 'type'=>'integer', 'label'=>'Num Entries', 'description'=>'The number of values to show by default.', 'default' => '5'),
			'showAsDropDown' => array('property' => 'showAsDropDown', 'type' => 'checkbox', 'label' => 'Drop Down?', 'description'=>'Whether or not the facets should be shown in a drop down list', 'default'=>'0'),
			'sortMode' => array('property'=>'sortMode', 'type'=>'enum', 'label'=>'Sort', 'values' => array('1' => 'Alphabetically', '0' => 'By number of results'), 'description'=>'How the facet values should be sorted.', 'default'=>'0'),
			'showAboveResults' => array('property' => 'showAboveResults', 'type' => 'checkbox', 'label' => 'Show Above Results', 'description'=>'Whether or not the facets should be shown above the results', 'default'=>0),
			'showInResults' => array('property' => 'showInResults', 'type' => 'checkbox', 'label' => 'Show on Results Page', 'description'=>'Whether or not the facets should be shown in regular search results', 'default'=>1),
			'showInAuthorResults' => array('property' => 'showInAuthorResults', 'type' => 'checkbox', 'label' => 'Show for Author Searches', 'description'=>'Whether or not the facets should be shown when searching by author', 'default'=>1),
			'showInAdvancedSearch' => array('property' => 'showInAdvancedSearch', 'type' => 'checkbox', 'label' => 'Show on Advanced Search', 'description'=>'Whether or not the facet should be an option on the Advanced Search Page', 'default'=>1),
			'collapseByDefault' => array('property' => 'collapseByDefault', 'type' => 'checkbox', 'label' => 'Collapse by Default', 'description'=>'Whether or not the facet should be an collapsed by default.', 'default'=>0),
			'useMoreFacetPopup' => array('property' => 'useMoreFacetPopup', 'type' => 'checkbox', 'label' => 'Use More Facet Popup', 'description'=>'Whether or not mroe facet options are shown in a popup box.', 'default'=>1),
		);
		return $structure;
	}

	function getEditLink(){
		return '/Admin/LibraryFacetSettings?objectAction=edit&id=' . $this->id;
	}

	function insert(){
		if (!is_numeric($this->sortMode)){
			$this->sortMode = 1;
		}
		parent::insert();
	}

	function update($dataObject = false){
		if (!is_numeric($this->sortMode)){
			$this->sortMode = 1;
		}
		parent::update($dataObject);
	}

	function setupTopFacet($facetName, $displayName){
		$this->facetName = $facetName;
		$this->displayName = $displayName;
		$this->showAsDropDown = false;
		$this->sortMode = 1;
		$this->showAboveResults = true;
		$this->showInResults = true;
		$this->showInAuthorResults = true;
		$this->showInAdvancedSearch = true;
		$this->numEntriesToShowByDefault = 0;
	}

	function setupSideFacet($facetName, $displayName, $collapseByDefault){
		$this->facetName = $facetName;
		$this->displayName = $displayName;
		$this->showAsDropDown = false;
		$this->sortMode = 1;
		$this->showAboveResults = false;
		$this->showInResults = true;
		$this->showInAuthorResults = true;
		$this->showInAdvancedSearch = true;
		$this->collapseByDefault = $collapseByDefault;
		$this->useMoreFacetPopup = true;
	}

	function setupAdvancedFacet($facetName, $displayName){
		$this->facetName = $facetName;
		$this->displayName = $displayName;
		$this->showAsDropDown = false;
		$this->sortMode = 1;
		$this->showAboveResults = false;
		$this->showInResults = false;
		$this->showInAuthorResults = false;
		$this->showInAdvancedSearch = true;
		$this->collapseByDefault = true;
		$this->useMoreFacetPopup = true;
	}
}