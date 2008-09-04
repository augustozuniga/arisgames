<?php

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

/**
 * Framework_Module_Main
 *
 * @author      Kevin Harris <klharris2@wisc.edu>
 * @package     Framework
 * @subpackage  Module
 */
class Framework_Module_Map extends Framework_Auth_User
{
    /**
     * __default
     * Displays a map, we didn't come here with a location to display
     *
     * @access      public
     * @return      mixed
     */
    public function __default()
    {
    	$site = Framework::$site;
    	$user = Framework_User::singleton();

    	$this->title = 'Current Location';

		$playerAtLocation = false; // a switch to use if a player is at a defined locaiton
		
		// Set up a marker for each location in the locations table
		$sql = Framework::$db->prefix("SELECT * FROM _P_locations 
			LEFT OUTER JOIN _P_player_events ON 
				_P_locations.require_event_id = _P_player_events.event_id
			WHERE latitude != '' AND longitude != ''
				AND (require_event_id IS NULL OR player_id = {$user->player_id})
				AND (_P_locations.remove_if_event_id IS NULL 
				OR _P_locations.remove_if_event_id NOT IN 
					(SELECT event_id FROM _P_player_events WHERE player_id = {$user->player_id}))");
		$rows = Framework::$db->getAll($sql);
		$this->allLocations = $rows;

		$mapPath = 'http://maps.google.com/staticmap?maptype=mobile&size='
			. $site->config->aris->map->width . 'x' 
			. $site->config->aris->map->height . '&key=' 
			. $site->config->aris->map->googleKey . '&markers=';
	 	$colors = array('green', 'purple', 'yellow', 'blue', 'gray', 'orange', 'red', 'white', 'black', 'brown');
		$letters = array('a','b','c','d','e','f','g','h','i','j','k');
		
		$i = 0;
		foreach ($rows as $row) {
			$lat = $row['latitude'];
			$long = $row['longitude'];
			$name = $row['name'];
			$lid = $row['location_id'];
			// add a marker (google seems to forgive the trailing | if it exists)
			$mapPath .= "$lat,$long,{$colors[$i]}{$letters[$i]}|";
			$i++;
		}

		// Cache the map_path for later updates
		$this->mapPathCache = $mapPath;
	
		// Set up a player icon and look for a matching location
		if (!empty($user->latitude) && !empty($user->longitude)) {
			// Add the player marker; TODO: put the color in the config file
			$mapPath .= $user->latitude . ',' . $user->longtitude . ','
				. $site->config->aris->map->playerColor;
		}
		
		$this->mapPath = $mapPath;

		$errorFactor = $site->config->aris->map->error;
		$sql = Framework::$db->prefix(sprintf("SELECT * FROM _P_locations WHERE 
			latitude <= %s AND latitude >= %s AND longitude <= %s AND longitude >= %s", 
			(real)$user->latitude + (real)$errorFactor,
			(real)$user->latitude - (real)$errorFactor, 
			(real)$user->longitude + (real)$errorFactor, 
			(real)$user->longitude - (real)$errorFactor));
		$row = Framework::$db->getRow($sql);
		
		// Set the current player location in the database
		if ($row) {
			$playerAtLocation = true;
			$this->player_location_id = $row['location_id'];
			$this->playerLocationName = $row['name'];
			$this->title = 'Near ' . $row['name'];
			
			$sql = Framework::$db->prefix("UPDATE _P_players 
				SET last_location_id = {$row['location_id']} 
				WHERE player_id = {$user->player_id}");
		}
		else {
			$this->player_location_id = -1;
			$sql = Framework::$db->prefix("UPDATE _P_players 
				SET last_location_id = '' WHERE player_id = {$user->player_id}");
		}
		Framework::$db->exec($sql);
    }
    
    /**
     * Displays the specified location information
     */
    public function displayLocation() {
    	if (empty($_REQUEST['location_id'])) {
    		$this->title = "mDesk Error";
    		$this->errorMessage = "Location cannot be determined at this time.";
    		return;
    	}
    	$locationID = $_REQUEST['location_id'];
    
		$user = Framework_User::singleton();
		$this->setPlayerLocation($user->player_id, $locationID);

		// Load the loaction data and display the name
		$sql = Framework::$db->prefix("SELECT * FROM _P_locations WHERE location_id = $locationID");
		$this->location = Framework::$db->getRow($sql);
		
		$sql = Framework::$db->prefix("SELECT * FROM _P_npcs 
			WHERE location_id = '$locationID' 
			AND (require_event_id IS NULL or require_event_id IN 
				(SELECT event_id FROM _P_player_events 
					WHERE player_id = {$user->player_id}))");
		$npcs = Framework::$db->getAll($sql);
		foreach ($npcs as &$npc) {
			if (!empty($npc['media'])) {
				$npc['media'] = $this->findMedia($npc['media'], 'defaultUser.png');
			}
		}
		unset($npc);
		
		$this->npcs = $npcs;
    	$this->title = $this->location['name'];
    	$this->event = 'faceConversation';
    }
    
    /**
     * Stores the player's location ID in the db.
     */
    protected function setPlayerLocation($playerID, $locationID) {
    	$sql = Framework::$db->prefix("UPDATE _P_players SET last_location_id = $locationID
			WHERE player_id = $playerID");
		Framework::$db->exec($sql);
    }
}
?>
