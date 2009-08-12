<?php
include('config.class.php');
include('returnData.class.php');

class Items 
{
	
	public function Items()
	{
		$this->conn = mysql_pconnect(Config::dbHost, Config::dbUser, Config::dbPass);
      	mysql_select_db (Config::dbSchema);
	}	
	
	/**
     * Fetch all Items
     * @returns the items
     */
	public function getItems($intGameID)
	{
		
		$prefix = $this->getPrefix($intGameID);
		if (!$prefix) return new returnData(2, NULL, "invalid game id");

		
		$query = "SELECT * FROM {$prefix}_items";
		NetDebug::trace($query);

		
		$rsResult = @mysql_query($query);
		
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
		if (!$prefix) return new returnData(2, NULL, "invalid game id");

		$query = "SELECT * FROM {$prefix}_items WHERE item_id = {$intItemID} LIMIT 1";
		
		$rsResult = @mysql_query($query);
		if (mysql_error()) return new returnData(1, NULL, "SQL Error");
		$item = mysql_fetch_object($rsResult);
		if (!$item) return new returnData(2, NULL, "No item");
		return new returnData(0, $item);
		
	}
	
	/**
     * Create an Item
     * @returns the new itemID on success
     */
	public function createItem($intGameID, $strName, $strDescription, $strMediaFileName)
	{
		
		$type = $this->getItemType($strMediaFileName);
		$prefix = $this->getPrefix($intGameID);
		if (!$prefix) return new returnData(2, NULL, "invalid game id");

		$query = "INSERT INTO {$prefix}_items 
					(name, description, media, type)
					VALUES ('{$strName}', '{$strDescription}','{$strMediaFileName}', '$type')";
		
		NetDebug::trace("createItem: Running a query = $query");	
		
		mysql_query($query);
		
		if (mysql_error()) return new returnData(1, NULL, "SQL Error");
		return new returnData(0, mysql_insert_id());
	}

	
	
	/**
     * Update a specific Item
     * @returns true if edit was done, false if no changes were made
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
		if (mysql_error()) return new returnData(1, NULL, "SQL Error");
		
		if (mysql_affected_rows()) {
			return new returnData(0, TRUE);
		}
		else {
			return new returnData(0, FALSE);
		}

	}
			
	
	/**
     * Delete an Item
     * @returns true if delete was done, false if no changes were made
     */
	public function deleteItem($intGameID, $intItemID)
	{
		$prefix = $this->getPrefix($intGameID);
		
		$query = "DELETE FROM {$prefix}_items WHERE item_id = {$intItemID}";
		
		$rsResult = mysql_query($query);
		if (mysql_error()) return new returnData(1, NULL, "SQL Error");
		
		if (mysql_affected_rows()) {
			return new returnData(0, TRUE);
		}
		else {
			return new returnData(0, FALSE);
		}
		
	}	
	
	
	/**
     * Fetch the prefix of a game
     * @returns a prefix string without the trailing _
     */
	private function getPrefix($intGameID) {
		//Lookup game information
		$query = "SELECT * FROM games WHERE game_id = '{$intGameID}'";
		$rsResult = mysql_query($query);
		if (mysql_num_rows($rsResult) < 1) return FALSE;
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