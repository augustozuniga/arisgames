<?php
include('config.class.php');

class Items 
{
	private $NAME 				= "Items";
	private $VERSION			= "0.0.1";
	
	
	public function Items()
	{
		$this->conn = mysql_pconnect(Config::dbHost, Config::dbUser, Config::dbPass);
      	mysql_select_db (Config::dbSchema);
	}	
	
	/**
     * Fetch all Items
     * @returns the items rs
     */
	public function getItems($intGameID)
	{
		
		$prefix = $this->getPrefix($intGameID);
		
		$query = "SELECT * FROM {$prefix}_items";
		
		$rsResult = mysql_query($query);
		return $rsResult;
		
	}
	
	/**
     * Fetch a specific nodes
     * @returns a single node
     */
	public function getItem($intGameID, $intItemID)
	{
		
		$prefix = $this->getPrefix($intGameID);
		
		$query = "SELECT * FROM {$prefix}_items WHERE node_id = {$intNodeID} LIMIT 1";
		
		$rsResult = mysql_query($query);
		return $rsResult;
		
	}
	
	/**
     * Create an Item
     * @returns the new itemID on success
     */
	public function createItem($intGameID, $strName, $strDescription, $strMediaFileName)
	{
		
		$type = $this->getItemType($strMediaFileName);
		$prefix = $this->getPrefix($intGameID);
		
		$query = "INSERT INTO {$prefix}_items 
					(name, description, media, type)
					VALUES ('{$strName}', '{$strDescription}','{$strMediaFileName}', '$type')";
		
		NetDebug::trace("createItem: Running a query = $query");	
		
		mysql_query($query);
		
		if (mysql_error()) {
			NetDebug::trace("createItem: SQL Error = " . mysql_error());
			return false;
		}
		return mysql_insert_id();
	}

	
	
	/**
     * Update a specific Item
     * @returns true on success
     */
	public function updateItem($intGameID, $intItemID, $strName, $strDescription, $strMediaFileName)
	{
		$type = $this->getItemType($strMediaFileName);
		$prefix = $this->getPrefix($intGameID);
		
		$query = "UPDATE {$prefix}_items 
					SET name = '{$strName}', description = '{$strDescription}', 
					media = '{$strMediaFileName}', type = '{$type}'
					WHERE item_id = '{$intItemID}'";
		
		NetDebug::trace("updateNpc: Running a query = $query");	
		
		mysql_query($query);
		
		if (mysql_affected_rows()) {
			NetDebug::trace("updateNpc: Item record modified");
			return true;
		}
		else {
			NetDebug::trace("updateNpc: No records affected. There must not have been a matching record in that game");
			return false;
		}

	}
			
	
	/**
     * Fetch a specific nodes
     * @returns a single node
     */
	public function deleteItem($intGameID, $intItemID)
	{
		$prefix = $this->getPrefix($intGameID);
		
		$query = "DELETE FROM {$prefix}_items WHERE item_id = {$intItemID}";
		
		$rsResult = mysql_query($query);
		return $rsResult;
		
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
	
	/**
     * Determine the Item Type
     * @returns either "AV" or "Image"
     */
	private function getItemType($strMediaFileName) {
		$mediaParts = pathinfo($strMediaFileName);
 		$mediaExtension = $mediaParts['extension'];
 		
 		if ($mediaExtension == '' or $mediaExtension == 'png' or $mediaExtension == 'jpg' ) $type = 'Image';
 		else $type = 'AV'; //We should improve this and do a more robust test
 		
 		NetDebug::trace("getITemType: Item type for '{$strMediaFileName}' is '{$type}'");
 		return $type;
 		
 	}
	
}