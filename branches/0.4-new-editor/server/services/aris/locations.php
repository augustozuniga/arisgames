<?php
require("module.php");


class Locations extends Module
{

	/**
     * Fetch all Locations
     * @returns the locations rs
     */
	public function getLocations($intGameID)
	{
		$prefix = $this->getPrefix($intGameID);
		if (!$prefix) return new returnData(1, NULL, "invalid game id");
		
		
		$query = "SELECT * FROM {$prefix}_locations";
		$rsResult = @mysql_query($query);
		
		if (mysql_error()) return new returnData(3, NULL, "SQL Error");
		return new returnData(0, $rsResult);	
	}
	
	
	/**
     * Fetch all locations for a given player
     * @returns the locations that meet requirements and have a qty > 0
     */
	public function getLocationsForPlayer($intGameID, $intPlayerID)
	{
		$prefix = $this->getPrefix($intGameID);
		if (!$prefix) return new returnData(1, NULL, "invalid game id");
		
		$query = "SELECT * FROM {$prefix}_locations 
				WHERE latitude != '' AND longitude != ''
				AND (type != 'Item' OR (item_qty IS NULL OR item_qty > 0))
				";
		$rsLocations = @mysql_query($query);
		if (mysql_error()) return new returnData(3, NULL, "SQL Error");
		
		$arrayLocations = array();
		
		while ($location = mysql_fetch_object($rsLocations)) {
			//If location and object it links to meet requirments, add it to the array
		
			if ($this->objectMeetsRequirements ($prefix, $intPlayerID, 'Location', $location->location_id)
				AND
				$this->objectMeetsRequirements ($prefix, $intPlayerID, $location->type, $location->type_id)
				)
				$arrayLocations[] = $location;
		}
		
		return new returnData(0, $arrayLocations);
	}
	
	
	
	
	/**
     * Fetch a specific location
     * @returns a single location
     */
	public function getLocation($intGameID, $intLocationID)
	{
		$prefix = $this->getPrefix($intGameID);
		if (!$prefix) return new returnData(1, NULL, "invalid game id");

		$query = "SELECT * FROM {$prefix}_locations WHERE location_id = {$intLocationID} LIMIT 1";
	
		$rsResult = @mysql_query($query);
		if (mysql_error()) return new returnData(3, NULL, "SQL Error");
		$location = mysql_fetch_object($rsResult);
		if (!$location) return new returnData(2, NULL, "No matching location");
		return new returnData(0, $location);
	}
		
	
	
	
	/**
     * Places an Item on the map
     * @returns the new locationID on success
     */
	public function createLocationForItem($intGameID, $intIconMediaID, 
								$dblLatitude, $dblLongitude, $dblError,
								$intItemId, $intQuantity, 
								$boolHidden, $boolForceView)
	{
		$prefix = $this->getPrefix($intGameID);
		if (!$prefix) return new returnData(1, NULL, "invalid game id");

		//Lookup the name of the item
		$query = "SELECT name FROM {$prefix}_items 
				WHERE item_id = '{$intItemId}' LIMIT 1";
		NetDebug::trace("createLocationForItem: Lookup Item query: $query");		
		
		$item = mysql_fetch_array(mysql_query($query));
		if (!$item) return new returnData(2, NULL, "No matching Item");

		
		$query = "INSERT INTO {$prefix}_locations 
					(name, icon_media_id, latitude, longitude, error, 
					type, type_id, item_qty, hidden, force_view)
					VALUES ('{$item['name']}', '{$intIconMediaID}',
							'{$dblLatitude}','{$dblLongitude}','{$dblError}',
							'Item','{$intItemId}','{$intQuantity}',
							'{$boolHidden}','{$boolForceView}')";
		
		NetDebug::trace("createLocationForItem: Running a query = $query");	
	
		@mysql_query($query);
		
		if (mysql_error()) {
			NetDebug::trace("createLocationForItem: SQL Error = " . mysql_error());
			return new returnData(3, NULL, "SQL Error");
		}
		return new returnData(0, mysql_insert_id());

	}


	
	/**
     * Places an Node on the map
     * @returns the new locationID on success
     */
	public function createLocationForNode($intGameID, $intIconMediaID, 
								$dblLatitude, $dblLongitude, $dblError,
								$intNodeId, $boolHidden, $boolForceView)
	{
		$prefix = $this->getPrefix($intGameID);
		if (!$prefix) return new returnData(1, NULL, "invalid game id");

		//Lookup the name of the item
		$query = "SELECT title FROM {$prefix}_nodes 
				WHERE node_id = '{$intNodeId}' LIMIT 1";
		NetDebug::trace("createLocationForNode: Lookup Node query: $query");		
		$node = mysql_fetch_array(mysql_query($query));
		if (!$node)  return new returnData(2, NULL, "No matching Node");

		$query = "INSERT INTO {$prefix}_locations 
					(icon_media_id, name, 
					latitude, longitude, error, 
					type, type_id, hidden, force_view)
					VALUES ('{$intIconMediaID}','{$node['title']}',
							'{$dblLatitude}','{$dblLongitude}','{$dblError}',
							'Node','{$intNodeId}','{$boolHidden}','{$boolForceView}')";
		
		NetDebug::trace("createLocationForNode: Running a query = $query");	
	
		@mysql_query($query);
		
		if (mysql_error()) {
			NetDebug::trace("createLocationForNode: SQL Error = " . mysql_error());
			return new returnData(3, NULL, "SQL Error");
		}
		return new returnData(0, mysql_insert_id());
	}


	/**
     * Places an Npc on the map
     * @returns the new locationID on success
     */
	public function createLocationForNpc($intGameID, $intIconMediaID, 
								$dblLatitude, $dblLongitude, $dblError,
								$intNpcId, $boolHidden, $boolForceView)
	{
		$prefix = $this->getPrefix($intGameID);
		if (!$prefix) return new returnData(1, NULL, "invalid game id");

		//Lookup the name of the item
		$query = "SELECT name FROM {$prefix}_npcs 
				WHERE npc_id = '{$intNpcId}' LIMIT 1";
		NetDebug::trace("createLocationForNode: Lookup Npc query: $query");		
		$npc = mysql_fetch_array(mysql_query($query));
		if (!$npc) return new returnData(2, NULL, "No matching NPC");

		
		$query = "INSERT INTO {$prefix}_locations 
					(icon_media_id, name, 
					latitude, longitude, error, 
					type, type_id, hidden, force_view)
					VALUES ('{$intIconMediaID}','{$npc['name']}',
							'{$dblLatitude}','{$dblLongitude}','{$dblError}',
							'Npc','{$intNpcId}','{$boolHidden}','{$boolForceView}')";
		
		NetDebug::trace("createLocationForNpc: Running a query = $query");	
	
		@mysql_query($query);
		
		if (mysql_error()) {
			NetDebug::trace("createLocationForNopc: SQL Error = " . mysql_error());
			return new returnData(3, NULL, "SQL Error");
		}
		return new returnData(0, mysql_insert_id());
	}

	/**
     * Updates the attributes of a Location
     * @returns true if a record was modified, false if no changes were required (could be from not matching the location id)
     */
	public function updateAttributes($intGameID, $intLocationId, 
								$intQuantity, $boolHidden, $boolForceView )
	{
		$prefix = $this->getPrefix($intGameID);
		if (!$prefix) return new returnData(1, NULL, "invalid game id");

		//Lookup the name of the item
		$query = "UPDATE {$prefix}_locations
				SET 
				item_qty = '{$intQuantity}',
				hidden = '{$boolHidden}'
				force_view = '{$boolForceView}'
				WHERE location_id = '{$intLocationId}'";
		NetDebug::trace("deleteLocation: Query: $query");		
		
		@mysql_query($query);
		if (mysql_error()) return new returnData(3, NULL, "SQL Error");
		
		if (mysql_affected_rows()) {
			return new returnData(0, TRUE);
		}
		else {
			return new returnData(0, FALSE);
		}
		
	}	

	/**
     * Deletes a Location
     * @returns true if a location was deleted, false if no changes were required (could be from not matching the location id)
     */
	public function deleteLocation($intGameID, $intLocationId)
	{
		$prefix = $this->getPrefix($intGameID);
		if (!$prefix) return new returnData(1, NULL, "invalid game id");

		//Lookup the name of the item
		$query = "DELETE FROM {$prefix}_locations 
				WHERE location_id = '{$intLocationId}'";
		NetDebug::trace("deleteLocation: Query: $query");		
		
		@mysql_query($query);
		if (mysql_error()) return new returnData(3, NULL, "SQL Error");
		
		if (mysql_affected_rows()) {
			return new returnData(0, TRUE);
		}
		else {
			return new returnData(0, FALSE);
		}	}
			
	
	/**
     * Fetch the valid content types from the requirements table
     * @returns an array of strings
     */
	public function objectTypeOptions($intGameID){	
		$options = $this->lookupObjectTypeOptionsFromSQL($intGameID);
		if (!$options) return new returnData(1, NULL, "invalid game id");
		return new returnData(0, $options);
	}
	
	
	/**
     * Check if a content type is valid
     * @returns TRUE if valid
     */
	private function isValidObjectType($intGameID, $strObjectType) {
		$validTypes = $this->lookupObjectTypeOptionsFromSQL($intGameID);
		return in_array($strObjectType, $validTypes);
	}
	
	
	/**
     * Fetch the valid requirement types from the requirements table
     * @returns an array of strings
     */
	private function lookupObjectTypeOptionsFromSQL($intGameID){
		$prefix = $this->getPrefix($intGameID);
		if (!$prefix) return FALSE;
		
		$query = "SHOW COLUMNS FROM {$prefix}_locations LIKE 'type'";
		$result = mysql_query( $query );
		$row = mysql_fetch_array( $result , MYSQL_NUM );
		$regex = "/'(.*?)'/";
		preg_match_all( $regex , $row[1], $enum_array );
		$enum_fields = $enum_array[1];
		return( $enum_fields );
	}	
	
	

	
	
	
	
}