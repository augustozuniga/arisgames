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
     * Fetch a specific npc
     * @returns a single npc
     */
	public function getNpc($intGameID, $intNpcID)
	{
		
		$prefix = $this->getPrefix($intGameID);
		
		$query = "SELECT * FROM {$prefix}_npcs WHERE npc_id = {$intNpcID} LIMIT 1";
		
		$rsResult = mysql_fetch_object(mysql_query($query));
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
     * Delete a specific NPC
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
     * Create a conversation option for the NPC to link to a node
     * @returns the new conversationID on success
     */
	public function createConversation($intGameID, $intNpcID, $intNodeID, $strText)
	{
		$prefix = $this->getPrefix($intGameID);
		
		$query = "INSERT INTO {$prefix}_npc_conversations 
					(npc_id, node_id, text)
					VALUES ('{$intNpcID}', '{$intNodeID}', '{$strText}')";
		
		NetDebug::trace("createConversation: Running a query = $query");	
		
		mysql_query($query);
		
		if (mysql_error()) {
			NetDebug::trace("createNConversation: SQL Error = " . mysql_error());
			return false;
		}
		return mysql_insert_id();
	}
	
	
	
	
	/**
     * Fetch the conversations for a given NPC
     * @returns a recordset of conversations
     */
	public function getConversations($intGameID, $intNpcID) {
		$prefix = $this->getPrefix($intGameID);
		$query = "SELECT * FROM {$prefix}_npc_conversations WHERE npc_id = '{$intNpcID}'";
		
		NetDebug::trace("getConversations: Running a query = $query");	

		$rsResult = mysql_query($query);
		return $rsResult;
		
	}	
	
	
	/**
     * Update Conversation
     * @returns true on success
     */
	public function updateConversation($intGameID, $intConverationID, $intNewNPC, $intNewNode, $strNewText)
	{
		$prefix = $this->getPrefix($intGameID);
		
		$query = "UPDATE {$prefix}_npc_conversations 
		SET npc_id = '{$intNewNPC}', node_id = '{$intNewNode}', text = '{$strNewText}'
		WHERE conversation_id = {$intConverationID}";
		
		$rsResult = mysql_query($query);
		
		if (mysql_affected_rows()) {
			NetDebug::trace("updateConversation: NPC Conversation record updated");
			return true;
		}
		else {
			NetDebug::trace("updateConversation: No records affected. There must not have been a matching record in that game");
			return false;
		}
		
	}	
	

	/**
     * Delete a specific NPC Conversation option
     * @returns true on success
     */
	public function deleteConversation($intGameID, $intConverationID)
	{
		$prefix = $this->getPrefix($intGameID);
		
		$query = "DELETE FROM {$prefix}_npc_conversations WHERE conversation_id = {$intConverationID}";
		
		$rsResult = mysql_query($query);
		
		if (mysql_affected_rows()) {
			NetDebug::trace("deleteConversation: NPC Conversation record deleted");
			return true;
		}
		else {
			NetDebug::trace("deleteConversation: No records affected. There must not have been a matching record in that game");
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