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
		
		// Set up a marker for each location in the locations table
		$pointsString = '';
		$sql = Framework::$db->prefix("SELECT * FROM _P_locations 
									  LEFT OUTER JOIN _P_player_events ON 
									  _P_locations.require_event_id = _P_player_events.event_id
									  WHERE latitude != '' AND longitude != ''
									  AND (require_event_id IS NULL OR player_id = {$user->player_id})
									  AND (_P_locations.remove_if_event_id IS NULL 
									  OR _P_locations.remove_if_event_id NOT IN (SELECT event_id FROM _P_player_events WHERE player_id = {$user->player_id}))
									  AND hidden != '1'");
		$rows = Framework::$db->getAll($sql);
		$this->allLocations = $rows;
		
		foreach ($rows as $row) {
			$lat = $row['latitude'];
			$long = $row['longitude'];
			$name = $row['name'];
			$lid = $row['location_id'];
			// add a marker (google seems to forgive the trailing | if it exists)
			$pointsString  .= "marker = new GMarker(new GLatLng($lat, $long));
								map.addOverlay(marker);
								bounds.extend(marker.getPoint());";
		}
		
		// Set up a player icon and look for a matching location
		if (!empty($user->latitude) && !empty($user->longitude)) {
			$pointsString  .= "marker = new GMarker(new GLatLng($user->latitude, $user->longitude));
								map.addOverlay(marker);
								bounds.extend(marker.getPoint());";		
		}
		
		
		$this->rawHead = '<script src="http://www.google.com/jsapi?key=' . $site->config->aris->map->googleKey . '"></script>
							<script type="text/javascript">
							google.load("maps", "2");
						</script>
						<script type="text/javascript">
							function initialize() {
									var map = new GMap2(document.getElementById("map_canvas"));
									map.addControl(new GSmallMapControl());
									map.addControl(new GMapTypeControl());
									var bounds = new GLatLngBounds();
									map.setCenter(new GLatLng(0,0),0);
									var bounds = new GLatLngBounds();
									' . $pointsString . '
									map.setZoom(map.getBoundsZoomLevel(bounds));
									map.setCenter(bounds.getCenter());
							}
						</script>';
		
		$this->mapWidth = $site->config->aris->map->width;
		$this->mapHeight = $site->config->aris->map->height;
		$this->title = 'Current Location';
		$this->onLoad = 'initialize()';
		$this->loadLocationAdmin($user);
    }
    
    
    /**
     * Loads the administration apps for the default view.
     */
    protected function loadLocationAdmin($user) {
    	if ($user->authorization > 0) {
    		$applications = array();
    		$applications[] = array('directory' => 'Map',
    			'name' => 'New', 'event' => 'addLocation');
    			
    		$this->adminApplications = $applications;
    	}
    }
	
	
    public function addLocation() {
    	$site = Framework::$site;
		
    	$this->title = 'Add New Location';
    	$this->mediaFiles = $this->getSiteMediaFiles();
		
    	$this->requireEvents = $this->getEvents();
    	$this->removeEvents = $this->requireEvents;
    }
	
	
}//class
?>
