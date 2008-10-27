<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * Framework_Module_Developer
 *
 * @author      Kevin Harris <klharris2@wisc.edu>
 * @author		David Gagnon <djgagnon@wisc.edu>
 * @package     Framework
 * @subpackage  Module
 */

class Framework_Module_Developer extends Framework_Auth_User
{
    /**
     * __default
     *
     * Shows Developer tools
     *
     * @access      public
     * @return      mixed
     */
    public function __default()
    {
    	$site = Framework::$site;
    	$user = Framework_User::singleton();
    	
    	$this->title = $site->config->aris->developer->title;
    	$this->loadLocations();

	}
	
	protected function loadLocations() {
		$sql = $this->db->prefix("SELECT * FROM _P_locations");
		$locations = $this->db->getAll($sql);
		
		foreach ($locations as &$location) {
			$name = $location['name'];
			$latitude = $location['latitude'];
			$longitude = $location['longitude'];
		}
		unset($location);
		
		$this->locations = $locations;
	}

}
?>
