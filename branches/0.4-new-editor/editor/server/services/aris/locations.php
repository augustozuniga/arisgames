<?php
include('config.class.php');

class Locations 
{
	private $NAME 				= "Locations";
	private $VERSION			= "0.0.1";
	
	
	public function Locations()
	{
		$this->conn = mysql_pconnect(Config::dbHost, Config::dbUser, Config::dbPass);
      	mysql_select_db (Config::dbSchema);
	}	
	
	
	/**
     * Fetch all Locations
     * @returns the locations rs
     */
	public function getLocations($intGameID)
	{
		$prefix = $this->getPrefix($intGameID);
		$query = "SELECT * FROM {$prefix}_locations";
		$rsResult = mysql_query($query);
		return $rsResult;	
	}
	
	/**
     * Fetch a specific nodes
     * @returns a single node
     */
	public function getLocation($intGameID, $intLocationID)
	{
		$prefix = $this->getPrefix($intGameID);
		
		$query = "SELECT * FROM {$prefix}_locations WHERE location_id = {$intNodeID} LIMIT 1";
	
		$rsResult = mysql_query($query);
		return $rsResult;
	}
		
	
	
	
	/**
     * Places an Item on the map
     * @returns the new locationID on success
     */
	public function createLocationForItem($intGameID, $strIcon, 
								$dblLatitude, $dblLongitude, $dblError,
								$intItemId, $intQuantity, 
								$boolHidden, $boolForceView)
	{
		$prefix = $this->getPrefix($intGameID);
		
		//Lookup the name of the item
		$query = "SELECT name FROM {$prefix}_items 
				WHERE item_id = '{$intItemId}' LIMIT 1";
		NetDebug::trace("createLocationForItem: Lookup Item query: $query");		
		$item = mysql_fetch_array(mysql_query($query));
		if (!$item) {
			NetDebug::trace("createLocationForItem: Error - Item not found");
			return false;
		}
		
		$query = "INSERT INTO {$prefix}_locations 
					(icon, name, latitude, longitude, error, 
					type, type_id, item_qty, hidden, force_view)
					VALUES ('{$strIcon}','{$item['name']}',
							'{$dblLatitude}','{$dblLongitude}','{$dblError}',
							'Item','{$intItemId}','{$intQuantity}',
							'{$boolHidden}','{$boolForceView}')";
		
		NetDebug::trace("createLocationForItem: Running a query = $query");	
	
		mysql_query($query);
		
		if (mysql_error()) {
			NetDebug::trace("createLocationForItem: SQL Error = " . mysql_error());
			return false;
		}
		return mysql_insert_id();
	}


	
	/**
     * Places an Node on the map
     * @returns the new locationID on success
     */
	public function createLocationForNode($intGameID, $strIcon, 
								$dblLatitude, $dblLongitude, $dblError,
								$intNodeId, $boolHidden, $boolForceView)
	{
		$prefix = $this->getPrefix($intGameID);
		
		//Lookup the name of the item
		$query = "SELECT title FROM {$prefix}_nodes 
				WHERE node_id = '{$intNodeId}' LIMIT 1";
		NetDebug::trace("createLocationForNode: Lookup Node query: $query");		
		$node = mysql_fetch_array(mysql_query($query));
		if (!$node) {
			NetDebug::trace("createLocationForNode: Error - Node not found");
			return false;
		}

		
		$query = "INSERT INTO {$prefix}_locations 
					(icon, name, 
					latitude, longitude, error, 
					type, type_id, hidden, force_view)
					VALUES ('{$strIcon}','{$node['title']}',
							'{$dblLatitude}','{$dblLongitude}','{$dblError}',
							'Node','{$intINodeId}','{$boolHidden}','{$boolForceView}')";
		
		NetDebug::trace("createLocationForNode: Running a query = $query");	
	
		mysql_query($query);
		
		if (mysql_error()) {
			NetDebug::trace("createLocationForNode: SQL Error = " . mysql_error());
			return false;
		}
		return mysql_insert_id();
	}


	/**
     * Places an Npc on the map
     * @returns the new locationID on success
     */
	public function createLocationForNpc($intGameID, $strIcon, 
								$dblLatitude, $dblLongitude, $dblError,
								$intNpcId, $boolHidden, $boolForceView)
	{
		$prefix = $this->getPrefix($intGameID);
		
		//Lookup the name of the item
		$query = "SELECT name FROM {$prefix}_npcs 
				WHERE npc_id = '{$intNpcId}' LIMIT 1";
		NetDebug::trace("createLocationForNode: Lookup Npc query: $query");		
		$npc = mysql_fetch_array(mysql_query($query));
		if (!$npc) {
			NetDebug::trace("createLocationForNpc: Error - NPC not found");
			return false;
		}

		
		$query = "INSERT INTO {$prefix}_locations 
					(icon, name, 
					latitude, longitude, error, 
					type, type_id, hidden, force_view)
					VALUES ('{$strIcon}','{$npc['name']}',
							'{$dblLatitude}','{$dblLongitude}','{$dblError}',
							'Npc','{$intINpcId}','{$boolHidden}','{$boolForceView}')";
		
		NetDebug::trace("createLocationForNpc: Running a query = $query");	
	
		mysql_query($query);
		
		if (mysql_error()) {
			NetDebug::trace("createLocationForNopc: SQL Error = " . mysql_error());
			return false;
		}
		return mysql_insert_id();
	}

	/**
     * Deletes a Location
     * @returns true on success
     */
	public function updateAttributes($intGameID, $intLocationId, 
								$intQuantity, $boolHidden, $boolForceView )
	{
		$prefix = $this->getPrefix($intGameID);
		
		//Lookup the name of the item
		$query = "UPDATE {$prefix}_locations
				SET 
				item_qty = '{$intQuantity}',
				hidden = '{$boolHidden}'
				force_view = '{$boolForceView}'
				WHERE location_id = '{$intLocationId}'";
		NetDebug::trace("deleteLocation: Query: $query");		
		return mysql_query($query);
	}	

	/**
     * Deletes a Location
     * @returns true on success
     */
	public function deleteLocation($intGameID, $intLocationId)
	{
		$prefix = $this->getPrefix($intGameID);
		
		//Lookup the name of the item
		$query = "DELETE FROM {$prefix}_locations 
				WHERE location_id = '{$intLocationId}'";
		NetDebug::trace("deleteLocation: Query: $query");		
		return mysql_query($query);
	}
			
	
	
	/**
     * Fetch the prefix of a game
     * @returns a prefix string without the trailing _
     */
	private function getPrefix($intGameID) {
		//Lookup game information
		$query = "SELECT * FROM games WHERE game_id = '{$intGameID}'";
		$rsResult = mysql_query($query);
		if (mysql_num_rows($rsResult) < 1) return 'ERROR: game id not found';
		$gameRecord = mysql_fetch_array($rsResult);
		return substr($gameRecord['prefix'],0,strlen($row['prefix'])-1);
		
	}
}