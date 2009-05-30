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
		
		// Set up a marker for each location in the locations table
		$pointsString = '';
		$sql = Framework::$db->prefix("SELECT * FROM _P_locations 
									  LEFT OUTER JOIN _P_player_events ON 
									  _P_locations.require_event_id = _P_player_events.event_id
									  WHERE latitude != '' AND longitude != ''
									  AND (type != 'Item' OR (item_qty IS NULL OR item_qty > 0))
									  AND (require_event_id IS NULL OR player_id = {$user['player_id']})
									  AND (_P_locations.remove_if_event_id IS NULL 
									  OR _P_locations.remove_if_event_id NOT IN (SELECT event_id FROM _P_player_events WHERE player_id = {$user['player_id']}))");
		$rows = Framework::$db->getAll($sql);
		$this->locations = $rows;
		
		// Set up a marker for each player
		$site = Framework::$site->name;
		$sql = Framework::$db->prefix("SELECT * FROM players 
									  WHERE site = '$site' 
									  AND latitude IS NOT NULL
									  AND longitude IS NOT NULL
									  AND player_id != {$user['player_id']}");
		$rows = Framework::$db->getAll($sql);
		$this->players = $rows;
		
	}
		
}//class
?>
