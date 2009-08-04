<?php
include('config.class.php');

class Nodes 
{
	private $NAME 				= "Nodes";
	private $VERSION			= "0.0.1";
	
	
	public function Nodes()
	{
		$this->conn = mysql_pconnect(Config::dbHost, Config::dbUser, Config::dbPass);
      	mysql_select_db (Config::dbSchema);
	}
	
	
	/**
     * Fetch all nodes
     * @returns the nodes rs
     */
	public function getNodes($intGameID)
	{
		
		$prefix = $this->getPrefix($intGameID);
		
		$query = "SELECT * FROM {$prefix}_nodes";
		
		$rsResult = mysql_query($query);
		return $rsResult;
		
	}
	
	/**
     * Fetch a specific nodes
     * @returns a single node
     */
	public function getNode($intGameID, $intNodeID)
	{
		
		$prefix = $this->getPrefix($intGameID);
		
		$query = "SELECT * FROM {$prefix}_nodes WHERE node_id = {$intNodeID} LIMIT 1";
		
		$rsResult = mysql_query($query);
		return $rsResult;
		
	}
	
	
	/**
     * Update a specific nodes
     * @returns true on success
     */
	public function updateNode($intGameID, $intNodeID, $strTitle, $strText, $strMedia,
								$strOpt1Text, $intOpt1NodeID, 
								$strOpt2Text, $intOpt2NodeID,
								$strOpt3Text, $intOpt3NodeID,
								$strQACorrectAnswer, $intQAIncorrectNodeID, $intQACorrectNodeID)
	{
		
	}
	
	
	/**
     * Fetch a specific nodes
     * @returns a single node
     */
	public function deleteNode($intGameID, $intNodeID)
	{
		$prefix = $this->getPrefix($intGameID);
		
		$query = "DELETE FROM {$prefix}_nodes WHERE node_id = {$intNodeID}";
		
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