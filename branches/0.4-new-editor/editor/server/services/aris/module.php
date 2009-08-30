<?php
require_once('config.class.php');
require_once('returnData.class.php');

abstract class Module
{
	
	private $validImageTypes = array('jpg','png');
	private $validAudioTypes = array('mp3','m4a');
	private $validVideoTypes = array('mp4','m4v');
	
	
	public function Module()
	{
		$this->conn = mysql_pconnect(Config::dbHost, Config::dbUser, Config::dbPass);
      	mysql_select_db (Config::dbSchema);
	}	
	
	/**
     * Fetch the prefix of a game
     * @returns a prefix string without the trailing _
     */
	protected function getPrefix($intGameID) {
		//Lookup game information
		$query = "SELECT * FROM games WHERE game_id = '{$intGameID}'";
		$rsResult = @mysql_query($query);
		if (mysql_num_rows($rsResult) < 1) return FALSE;
		$gameRecord = mysql_fetch_array($rsResult);
		return substr($gameRecord['prefix'],0,strlen($row['prefix'])-1);
		
	}
	
	
	
    /**
     * Adds the specified item to the specified player.
     */
     protected function giveItemToPlayer($strGamePrefix, $intItemID, $intPlayerID) {
		    	
    	$query = "INSERT INTO {$strGamePrefix}_player_items 
										  (player_id, item_id) VALUES ($intPlayerID, $intItemID)
										  ON duplicate KEY UPDATE item_id = $intItemID";
		@mysql_query($query);    	
    }
	
	
	/**
     * Removes the specified item from the user.
     */ 
    protected function takeItemFromPlayer($strGamePrefix, $intItemID, $intPlayerID) {

    	$query = "DELETE FROM {$strGamePrefix}_player_items 
					WHERE player_id = $intPlayerID AND item_id = $intItemID";
    	
    	@mysql_query($query);    	
    }
	
	/**
     * Decrement the item_qty at the specified location by the specified amount, default of 1
     */ 
    protected function decrementItemQtyAtLocation($strGamePrefix, $intLocationID, $intQty = 1) {
   		//If this location has a null item_qty, decrementing it will still be a null
		$query = "UPDATE {$strGamePrefix}_locations 
					SET item_qty = item_qty-{$intQty}
					WHERE location_id = '{$intLocationID}'";
    	@mysql_query($query);    	
	}
	
	
	/**
     * Adds an item to Locations at the specified latitude, longitude
     */ 
    protected function giveItemToWorld($strGamePrefix, $intItemID, $floatLat, $floatLong, $intQty = 1) {
		$itemName = $this->getItemName($strGamePrefix, $intItemID);
		$query = "INSERT INTO {$strGamePrefix}_locations (name, type, type_id, latitude, longitude, item_qty)
										  VALUES ('{$itemName}','Item','$intItemID}','{$floatLat}','{$floatLong}','{$intQty}')";
    	@mysql_query($query);    	
    }
	
    
    /**
    * Checks if a record Exists
    **/
    protected function recordExists($strPrefix, $strTable, $intRecordID){
    	$key = substr($strTable, 0, strlen($strTable)-1);
    	$query = "SELECT * FROM {$strPrefix}_{$strTable} WHERE {$key} = $intRecordID";
    	$rsResult = @mysql_query($query);
		if (mysql_error()) return FALSE;
		if (mysql_num_rows($rsResult) < 1) return FALSE;
		return true;
    }
	
	/**
    * Looks up an item name
    **/
    protected function getItemName($strPrefix, $intItemID){
    	$query = "SELECT name FROM {$strPrefix}_items WHERE item_id = $intRecordID";
    	$rsResult = @mysql_query($query);		
		$row = @mysql_fetch_array($rsResult);	
		return $row['name'];
    }
	

	/**
     * Determine the Item Type
     * @returns "Audio", "Video" or "Image"
     */
	protected function getMediaType($strMediaFileName) {
		$mediaParts = pathinfo($strMediaFileName);
 		$mediaExtension = $mediaParts['extension'];
 		
 		if (in_array($mediaExtension, $this->validImageTypes )) return 'Image';
 		else if (in_array($mediaExtension, $this->validAudioTypes )) return 'Audio';
		else if (in_array($mediaExtension, $this->validVideoTypes )) return'Video';
 		
 		return FALSE;
 	}	
	
	
	/** 
	 * checkForEvent
	 *
     * Checks if the specified user has the specified event.
	 *
     * @return boolean
     */
    protected function checkForEvent($strPrefix, $intPlayerID, $intEventID) {
		$query = "SELECT * FROM {$strPrefix}_player_events 
					WHERE player_id = '{$intPlayerID}' 
					AND event_id = '{$intEventID}'";
		
		$rsResult = @mysql_query($query);
		
		if (mysql_num_rows($rsResult) > 0) return true;
		else return false;
    }

	/** 
	 * checkForItem
	 *
     * Checks if the specified user has the specified event.
	 *
     * @return boolean
     */
    protected function checkForItem($strPrefix, $intPlayerID, $intItemID) {
		$query = "SELECT * FROM {$strPrefix}_player_items 
									  WHERE player_id = '$$intPlayerID' 
									  AND item_id = '$intItemID'";
		
		$rsResult = @mysql_query($query);
		
		if (mysql_num_rows($rsResult) > 0) return true;
		else return false;
    }		
	
	
	/** 
	 * objectMeetsRequirements
	 *
     * Checks all requirements for the specified object for the specified user
	 *
     * @return boolean
     */	
	function objectMeetsRequirements ($strPrefix, $intPlayerId, $strObjectType, $intObjectId) {		
		
		//Fetch the requirements
		$query = "SELECT * FROM {$strPrefix}_requirements 
					WHERE content_type = '{$strObjectType}' AND content_id = '{$intObjectId}'";
		$rsRequirments = @mysql_query($query);
		
		while ($requirement = mysql_fetch_array($rsRequirments)) {
			//var_dump ($requirement);
			
			//Check the requirement
			switch ($requirement['requirement']) {
				case 'HAS_EVENT':
					//echo 'Checking for an HAS_EVENT';
					if (!$this->checkForEvent($intPlayerId, $requirement['requirement_detail'])) return FALSE;
					break;
				case 'DOES_NOT_HAVE_EVENT':
					//echo 'Checking for an DOES_NOT_HAVE_EVENT';
					if ($this->checkForEvent($intPlayerId, $requirement['requirement_detail'])) return FALSE;
					break;
				case 'HAS_ITEM':
					//echo 'Checking for an HAS_ITEM';
					if (!$this->checkForItem($intPlayerId, $requirement['requirement_detail'])) return FALSE;
					break;
				case 'DOES_NOT_HAVE_ITEM':
					//echo 'Checking for a DOES_NOT_HAVE_ITEM';
					if ($this->checkForItem($intPlayerId, $requirement['requirement_detail'])) return FALSE;
					break;
			}
		}
		return TRUE;
	}	
	
	
	
	
	
	
	
	
	
}