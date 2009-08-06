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
     * Create a node
     * @returns the new nodeID on success
     */
	public function createNode($intGameID, $strTitle, $strText, $strMedia,
								$strOpt1Text, $intOpt1NodeID, 
								$strOpt2Text, $intOpt2NodeID,
								$strOpt3Text, $intOpt3NodeID,
								$strQACorrectAnswer, $intQAIncorrectNodeID, $intQACorrectNodeID)
	{
		$prefix = $this->getPrefix($intGameID);
		$query = "INSERT INTO {$prefix}_nodes 
					(title, text, media, 
						opt1_text, opt1_node_id, 
						opt2_text, opt2_node_id, 
						opt3_text, opt3_node_id,
						require_answer_string, 
						require_answer_incorrect_node_id, 
						require_answer_correct_node_id)
					VALUES ('{$strTitle}', '{$strText}', '{$strMedia}',
						'{$strOpt1Text}', '{$intOpt1NodeID}',
						'{$strOpt2Text}','{$intOpt2NodeID}',
						'{$strOpt3Text}','{$intOpt3NodeID}',
						'{$strQACorrectAnswer}', 
						'{$intQAIncorrectNodeID}', 
						'{$intQACorrectNodeID}')";
		
		NetDebug::trace("createNode: Running a query = $query");	
		
		mysql_query($query);
		
		if (mysql_error()) {
			NetDebug::trace("createNode: SQL Error = " . mysql_error());
			return false;
		}
		return mysql_insert_id();
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
		$prefix = $this->getPrefix($intGameID);
		$query = "UPDATE {$prefix}_nodes 
					SET title = '{$strTitle}', text = '{$strText}',
					media = '{$strMedia}',
					opt1_text = '{$strOpt1Text}', opt1_node_id = '{$intOpt1NodeID}',
					opt2_text = '{$strOpt2Text}', opt2_node_id = '{$intOpt2NodeID}',
					opt3_text = '{$strOpt3Text}', opt3_node_id = '{$intOpt3NodeID}',
					require_answer_string = '{$strQACorrectAnswer}', 
					require_answer_incorrect_node_id = '{$intQAIncorrectNodeID}', 
					require_answer_correct_node_id = '{$intQACorrectNodeID}'
					WHERE node_id = '{$intNodeID}'";
		
		NetDebug::trace("updateNode: Running a query = $query");	
		
		mysql_query($query);
		
		if (mysql_affected_rows()) {
			NetDebug::trace("updateNode: record modified");
			return true;
		}
		else {
			NetDebug::trace("updateNode: No records affected. There must not have been a matching record in that game");
			return false;
		}
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