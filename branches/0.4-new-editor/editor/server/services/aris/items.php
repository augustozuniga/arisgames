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
     * Update a specific nodes
     * @returns true on success
     */
	public function updateItem($intGameID, $intItemID, 
								$strName, $strDescription, $strMedia, $strType)
	{
		
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
	
	
}