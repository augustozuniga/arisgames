<?php
include('config.class.php');

class Npcs 
{
	private $NAME 				= "Npcs";
	private $VERSION			= "0.0.1";
	
	
	public function Npcs()
	{
		$this->conn = mysql_pconnect(Config::dbHost, Config::dbUser, Config::dbPass);
      	mysql_select_db (Config::dbSchema);
	}
	
	
	/**
     * Fetch all Npcs
     * @returns the npc rs
     */
	public function getNpcs($intGameID)
	{
		
		$prefix = $this->getPrefix($intGameID);
		
		$query = "SELECT * FROM {$prefix}_npcs";
		
		$rsResult = mysql_query($query);
		return $rsResult;
		
	}
	
	/**
     * Fetch a specific npcs
     * @returns a single npc
     */
	public function getNpc($intGameID, $intNpcID)
	{
		
		$prefix = $this->getPrefix($intGameID);
		
		$query = "SELECT * FROM {$prefix}_npcs WHERE npc_id = {$intNpcID} LIMIT 1";
		
		$rsResult = mysql_query($query);
		return $rsResult;
		
	}

	/**
     * Create a NPC
     * @returns the new npcID on success
     */
	public function createNpc($intGameID, $strName, $strDescription, $strGreeting, $strMedia)
	{
		$prefix = $this->getPrefix($intGameID);
		$query = "INSERT INTO {$prefix}_npcs 
					(name, description, text, media)
					VALUES ('{$strName}', '{$strDescription}', '{$strGreeting}','{$strMedia}')";
		
		NetDebug::trace("createNpc: Running a query = $query");	
		
		mysql_query($query);
		
		if (mysql_error()) {
			NetDebug::trace("createNode: SQL Error = " . mysql_error());
			return false;
		}
		return mysql_insert_id();
	}

	
	
	/**
     * Update a specific NPC
     * @returns true on success
     */
	public function updateNpc($intGameID, $intNpcID, 
								$strName, $strDescription, $strGreeting, $strMedia)
	{
		$prefix = $this->getPrefix($intGameID);
		$query = "UPDATE {$prefix}_npcs 
					SET name = '{$strName}', description = '{$strDescription}',
					text = '{$strGreeting}', media = '{$strMedia}'
					WHERE npc_id = '{$intNpcID}'";
		
		NetDebug::trace("updateNpc: Running a query = $query");	
		
		mysql_query($query);
		
		if (mysql_affected_rows()) {
			NetDebug::trace("updateNpc: NPC record modified");
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
	public function deleteNpc($intGameID, $intNpcID)
	{
		$prefix = $this->getPrefix($intGameID);
		
		$query = "DELETE FROM {$prefix}_npcs WHERE npc_id = {$intNpcID}";
		
		$rsResult = mysql_query($query);
		
		if (mysql_affected_rows()) {
			NetDebug::trace("updateNpc: NPC record deleted");
			return true;
		}
		else {
			NetDebug::trace("updateNpc: No records affected. There must not have been a matching record in that game");
			return false;
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
		if (mysql_num_rows($rsResult) < 1) return 'ERROR: game id not found';
		$gameRecord = mysql_fetch_array($rsResult);
		return substr($gameRecord['prefix'],0,strlen($row['prefix'])-1);
		
	}
	
	
}