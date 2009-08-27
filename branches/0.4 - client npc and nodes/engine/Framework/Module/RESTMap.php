<?php

include_once "RESTLoginLib.php";

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * Framework_Module_Main
 *
 * @author      Kevin Harris <klharris2@wisc.edu>
 * @author		David Gagnon <djgagnon@wisc.edu>
 * @copyright   Joe Stump <joe@joestump.net>
 * @package     Framework
 * @subpackage  Module
 * @filesource
 */


class Framework_Module_RESTMap extends Framework_Auth_User
{
    /**
     * __default
     * Displays a map, we didn't come here with a location to display
     *
     * @access      public
     * @return      mixed
     */
    public function __default() {
    	$this->pageTemplateFile = 'empty.tpl';
    	$user = loginUser();
    	
    	if(!$user) {
    		header("Location: {$_SERVER['PHP_SELF']}?module=RESTError&controller=Web&event=loginError&site=" . Framework::$site->name);
    		die;
    	}
    	
    	$site = Framework::$site;
		
		$this->chromeless = true;
		
		// Fetch all locations, checking the linked object's requirements
		//(that have a qty>0 if an item)
		
		$sql = Framework::$db->prefix("SELECT * FROM _P_locations 
										WHERE latitude != '' AND longitude != ''
										AND (type != 'Item' OR (item_qty IS NULL OR item_qty > 0))
									  ");
		$locations = Framework::$db->getAll($sql);
		$locations = $this->checkRequirementsForLocations($user, $locations);
				
		
		$this->locations = $locations;
		
		// Fetch other Player Locations
		$site = Framework::$site->name;
		$sql = Framework::$db->prefix("SELECT * FROM players 
									  WHERE site = '$site' 
									  AND latitude IS NOT NULL
									  AND longitude IS NOT NULL
									  AND player_id != {$user['player_id']}");
		$rows = Framework::$db->getAll($sql);
		$this->players = $rows;
		
	}
	
	function checkRequirementsForLocations($user, $locations){
		//echo "<p>Before Test:</p>";
		//var_dump($locations);
		
		//Check each Location for its requirements
		foreach ($locations as $locationkey => $location) {
			if (!$this->objectMeetsRequirements ($user, 'Location', $location['location_id'])) unset ($locations[$locationkey]);
		}
		
		//Check the Requirments of the Objects the Locations link to 
		foreach ($locations as $locationkey => $location) {
			if (!$this->objectMeetsRequirements ($user, $location['type'], $location['type_id'])) unset ($locations[$locationkey]);
		}
		
		//echo "<p>After Test:</p>";
		//var_dump($locations);
		return $locations;
	}
	
		
}//class
?>
