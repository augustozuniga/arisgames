<?php
require_once("module.php");
require_once("media.php");
require_once("games.php");
require_once("locations.php");
require_once("playerStateChanges.php");

class Items extends Module
{
	
	/**
     * Fetch all Items
     * @returns the items
     */
	public function getItems($intGameID)
	{
		
		$prefix = $this->getPrefix($intGameID);
		if (!$prefix) return new returnData(1, NULL, "invalid game id");

		
		$query = "SELECT * FROM {$prefix}_items";
		NetDebug::trace($query);

		
		$rsResult = @mysql_query($query);
		
		if (mysql_error()) return new returnData(1, NULL, "SQL Error");
		return new returnData(0, $rsResult);
	}
	
	/**
     * Fetch all Items in Player's inventory
     * @returns the items
     */
	public function getItemsForPlayer($intGameID, $intPlayerID)
	{
		
		$prefix = $this->getPrefix($intGameID);
		if (!$prefix) return new returnData(1, NULL, "invalid game id");

		
		$query = "SELECT {$prefix}_items.*, {$prefix}_player_items.qty 
					FROM {$prefix}_items
					JOIN {$prefix}_player_items 
					ON {$prefix}_items.item_id = {$prefix}_player_items.item_id
					WHERE player_id = $intPlayerID";
		NetDebug::trace($query);
		
		$rsResult = @mysql_query($query);
		if (!$rsResult) return new returnData(0, NULL);
		if (mysql_error()) return new returnData(1, NULL, "SQL Error");
		return new returnData(0, $rsResult);
	}	
	
	
	
	/**
     * Fetch a specific nodes
     * @returns a single node
     */
	public function getItem($intGameID, $intItemID)
	{
		
		$prefix = $this->getPrefix($intGameID);
		if (!$prefix) return new returnData(1, NULL, "invalid game id");

		$query = "SELECT * FROM {$prefix}_items WHERE item_id = {$intItemID} LIMIT 1";
		
		$rsResult = @mysql_query($query);
		if (mysql_error()) return new returnData(3, NULL, "SQL Error");
		
		$item = @mysql_fetch_object($rsResult);
		if (!$item) return new returnData(2, NULL, "invalid item id");
		
		return new returnData(0, $item);
		
	}
	
	/**
     * Create an Item
     * @returns the new itemID on success
     */
	public function createItem($intGameID, $strName, $strDescription, 
								$intIconMediaID, $intMediaID, $boolDropable, $boolDestroyable, $intMaxQuantityInPlayerInventory)
	{
		$strName = addslashes($strName);	
		$strDescription = addslashes($strDescription);	
		
		$prefix = $this->getPrefix($intGameID);
		if (!$prefix) return new returnData(1, NULL, "invalid game id");

		$query = "INSERT INTO {$prefix}_items 
					(name, description, icon_media_id, media_id, dropable, destroyable,max_qty_in_inventory)
					VALUES ('{$strName}', 
							'{$strDescription}',
							'{$intIconMediaID}', 
							'{$intMediaID}', 
							'$boolDropable',
							'$boolDestroyable',
							'$intMaxQuantityInPlayerInventory')";
		
		NetDebug::trace("createItem: Running a query = $query");	
		
		@mysql_query($query);
		if (mysql_error()) return new returnData(3, NULL, "SQL Error:" . mysql_error() . "while running query:" . $query);		
		
		return new returnData(0, mysql_insert_id());
	}
	
	/**
     * Create an Item and add it to the players inventory
     * @returns with returnData object (0 on success) 
     */
	public function createItemAndGiveToPlayer($intGameID, $intPlayerID, $strName, $strDescription, 
								$strFileName, $boolDropable, $boolDestroyable, $latitude, $longitude)
	{
		$prefix = $this->getPrefix($intGameID);
		if (!$prefix) return new returnData(1, NULL, "invalid game id");
		
		$strName = addslashes($strName);
		$strDescription = addslashes($strDescription);
		
		//Create the Media
		$newMediaResultData = Media::createMedia($intGameID, $strName, $strFileName, 0);
		$newMediaID = $newMediaResultData->data;
		
		//Does game allow players to drop items?
		if ($boolDropable) { 
			$game = Games::getGame($intGameID);
			$boolDropable = $game->data->allow_player_created_locations;
		}
		
		//Create the Item
		$query = "INSERT INTO {$prefix}_items 
					(name, description, media_id, dropable, destroyable,
					creator_player_id, origin_latitude, origin_longitude)
					VALUES ('{$strName}', 
							'{$strDescription}',
							'{$newMediaID}', 
							'$boolDropable',
							'$boolDestroyable',
							'$intPlayerID', '$latitude', '$longitude')";
		
		NetDebug::trace("createItem: Running a query = $query");	
		
		@mysql_query($query);
		if (mysql_error()) return new returnData(3, NULL, "SQL Error:" . mysql_error());
		
		$newItemID = mysql_insert_id();
		
		Module::appendLog($intPlayerID, $intGameID, Module::kLOG_UPLOAD_MEDIA_ITEM, $newItemID);

		$qty = 1;
		Module::giveItemToPlayer($prefix, $newItemID, $intPlayerID, $qty); 
		
		return new returnData(0, TRUE);
	}	

	/**
     * Create an Item and place it on the map
     * @returns with returnData object (0 on success) 
     */
	public function createItemAndPlaceOnMap($intGameID, $intPlayerID, $strName, $strDescription, 
								$strFileName, $boolDropable, $boolDestroyable, $latitude, $longitude)
	{
		$prefix = $this->getPrefix($intGameID);
		if (!$prefix) return new returnData(1, NULL, "invalid game id");
		
		$strName = addslashes($strName);
		$strDescription = ($strDescription);
		
		//Create the Media
		$newMediaResultData = Media::createMedia($intGameID, $strName, $strFileName, 0);
		$newMediaID = $newMediaResultData->data;
		
		//Does game allow players to drop items?
		if ($boolDropable) { 
			$game = Games::getGame($intGameID);
			$boolDropable = $game->data->allow_player_created_locations;
		}
		
		//Create the Item
		$query = "INSERT INTO {$prefix}_items 
					(name, description, media_id, dropable, destroyable,
					creator_player_id, origin_latitude, origin_longitude)
					VALUES ('{$strName}', 
							'{$strDescription}',
							'{$newMediaID}', 
							'$boolDropable',
							'$boolDestroyable',
							'$intPlayerID', '$latitude', '$longitude')";
		
		NetDebug::trace("createItem: Running a query = $query");	
		
		@mysql_query($query);
		if (mysql_error()) return new returnData(3, NULL, "SQL Error:" . mysql_error());
		
		$newItemID = mysql_insert_id();
		
		Module::appendLog($intPlayerID, $intGameID, Module::kLOG_UPLOAD_MEDIA_ITEM, $newItemID);

		Locations::createLocation($intGameID, $strName, 0, 
								$latitude, $longitude, 25,
								"Item", $newItemID,
								1, 0, 0);
		
		return new returnData(0, TRUE);
	}	
	
	
	/**
     * Update a specific Item
     * @returns true if edit was done, false if no changes were made
     */
	public function updateItem($intGameID, $intItemID, $strName, $strDescription, 
								$intIconMediaID, $intMediaID, $boolDropable, $boolDestroyable, $intMaxQuantityInPlayerInventory)
	{
		$prefix = $this->getPrefix($intGameID);
		
		$strName = addslashes($strName);	
		$strDescription = addslashes($strDescription);	
		
		if (!$prefix) return new returnData(1, NULL, "invalid game id");

		$query = "UPDATE {$prefix}_items 
					SET name = '{$strName}', 
						description = '{$strDescription}', 
						icon_media_id = '{$intIconMediaID}',
						media_id = '{$intMediaID}', 
						dropable = '{$boolDropable}',
						destroyable = '{$boolDestroyable}'
						max_qty_in_inventory = '{$intMaxQuantityInPlayerInventory}',
					WHERE item_id = '{$intItemID}'";
		
		NetDebug::trace("updateNpc: Running a query = $query");	
		
		@mysql_query($query);
		if (mysql_error()) return new returnData(3, NULL, "SQL Error:" . mysql_error() . "while running query:" . $query);
 		
		if (mysql_affected_rows()) return new returnData(0, TRUE, "Success Running:" . $query);
		else return new returnData(0, FALSE, "Success Running:" . $query);
		

	}
			
	
	/**
     * Delete an Item
     * @returns true if delete was done, false if no changes were made
     */
	public function deleteItem($intGameID, $intItemID)
	{
		$prefix = $this->getPrefix($intGameID);
		if (!$prefix) return new returnData(1, NULL, "invalid game id");
		
		Locations::deleteLocationsForObject($intGameID, 'Item', $intItemID);
		Requirements::deleteRequirementsForRequirementObject($intGameID, 'Item', $intItemID);
		PlayerStateChanges::deletePlayerStateChangesThatRefrenceObject($intGameID, 'Item', $intItemID);
		Module::removeItemFromAllPlayerInventories($prefix, $intItemID );
		
		$query = "DELETE FROM {$prefix}_items WHERE item_id = {$intItemID}";
		
		$rsResult = @mysql_query($query);
		if (mysql_error()) return new returnData(3, NULL, "SQL Error");
		
		if (mysql_affected_rows()) {
			return new returnData(0, TRUE);
		}
		else {
			return new returnData(0, FALSE);
		}
		
	}	
	
	
	/**
     * Get a list of objects that refer to the specified item
     * @returns a list of object types and ids
     */
	public function getReferrers($intGameID, $intItemID)
	{
		$prefix = $this->getPrefix($intGameID);
		if (!$prefix) return new returnData(1, NULL, "invalid game id");

		//Find locations
		$query = "SELECT location_id FROM {$prefix}_locations WHERE 
					type  = 'Item' and type_id = {$intItemID}";
		$rsLocations = @mysql_query($query);
		if (mysql_error()) return new returnData(3, NULL, "SQL Error in Locations query");
		
		//Find State Changes from other objects
		$query = "SELECT content_type, content_id FROM {$prefix}_player_state_changes WHERE
					action  =  'GIVE_ITEM' or
					action  =  'TAKE_ITEM'
					";
		$rsStateChanges = @mysql_query($query);
		if (mysql_error()) return new returnData(3, NULL, "SQL Error in state changes Query");
		
		//Combine them together
		$referrers = array();
		while ($row = mysql_fetch_array($rsLocations)){
			$referrers[] = array('type'=>'Location', 'id' => $row['location_id']);
		}

		while ($row = mysql_fetch_array($rsStateChanges)){
			$referrers[] = array('type'=>$row['content_type'], 'id' => $row['content_id']);
		}
		
		return new returnData(0,$referrers);
	}	


	
}