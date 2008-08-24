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
		$mapPathCache = $mapPath;
	
		// Set up a player icon and look for a matching location
		if (!empty($user->latitude) && !empty($user->longitude)) {
			// Add the player marker; TODO: put the color in the config file
			$mapPath .= $player->latitude . ',' . $player->longtitude . ','
				. $site->config->aris->map->playerColor;
		}
	
		$errorFactor = $site->config->aris->map->gpsError;
		$sql = Framework::$db->prefix(sprintf("SELECT * FROM _P_locations WHERE 
			latitude < %d AND latitude > %s AND longitude < %s AND longitude > %s", 
			$player->latitude + $gps_error_factor,
			$player->latitude - $gps_error_factor, 
			$player->longitude + $gps_error_factor, 
			$player->longitude - $gps_error_factor));
		$row = Framework::$db->getRow($sql);
		
		// Set the current player location in the database
		if ($row) {
			$playerAtLocation = true;
			$sql = Framework::$db->prefix("UPDATE _P_players 
				SET last_location_id = {$row['location_id']} 
				WHERE player_id = {$user->player_id}");
		}
		else $sql = Framework::$db->prefix("UPDATE _P_players 
			SET last_location_id = '' WHERE player_id = {$user->player_id}");
		Framework::$db->// Query?
	}
	
	
	//Display current location
	if ($player_at_location == true) echo "<h1><a href = '{$_SERVER['PHP_SELF']}?location_id=$row[location_id]'>Current Location: $row[name] </a></h1>";
	
	
	//Display the map
	echo "<p><img id='mapImg' src = '$map_path'/></p>";
	echo "<script type='text/javascript'>var map_cache = \"$map_path_cache\";</script>";

	
	//Display the Locatons as links under the map using the same letters as in the map
	$query = "SELECT * FROM {$GLOBALS['DB_TABLE_PREFIX']}locations 
				LEFT OUTER JOIN {$GLOBALS['DB_TABLE_PREFIX']}player_events 
				ON {$GLOBALS['DB_TABLE_PREFIX']}locations.require_event_id = {$GLOBALS['DB_TABLE_PREFIX']}player_events.event_id
				WHERE 
				(require_event_id IS NULL OR player_id = $_SESSION[player_id])
				and
				({$GLOBALS['DB_TABLE_PREFIX']}locations.remove_if_event_id IS NULL 
					OR 
					{$GLOBALS['DB_TABLE_PREFIX']}locations.remove_if_event_id NOT IN 
					(SELECT event_id FROM {$GLOBALS['DB_TABLE_PREFIX']}player_events WHERE player_id = 	$_SESSION[player_id])
				)";
				
	$locations_dataset = mysql_query($query);
	
	$i = 0;
	
	while( $location = mysql_fetch_array($locations_dataset) ) {					
		//echo "<p><a href = '{$_SERVER['PHP_SELF']}?location_id=$location[location_id]'>{$letters[$i]}. {$location['name']}</a></p>";
		$letter = strtoupper($letters[$i]);
		echo "<p>{$letter}. {$location['name']}</p>";
		$i++;
		
	}
	
    }
}

?>
