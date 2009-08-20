<?php
include('config.class.php');
include('returnData.class.php');
require_once ('fileVO.class.php');

class Media 
{
	
	
	private $validImageTypes = array('jpg','png');
	private $validAudioTypes = array('mp3','m4a');
	private $validVideoTypes = array('mp4','m4v');
	
	
	
	public function Media()
	{
		$this->conn = mysql_pconnect(Config::dbHost, Config::dbUser, Config::dbPass);
      	mysql_select_db (Config::dbSchema);
	}	
	
	/**
     * Fetch all Items
     * @returns the items
     */
	public function getMedia($intGameID)
	{
		
		$prefix = $this->getPrefix($intGameID);
		if (!$prefix) return new returnData(1, NULL, "invalid game id");

		
		$query = "SELECT * FROM {$prefix}_media";
		NetDebug::trace($query);

		
		$rsResult = @mysql_query($query);
		if (mysql_error()) return new returnData(1, NULL, "SQL Error");
		
		$returnData = new returnData(0, array());
		//Calculate the media types
		while ($mediaRow = mysql_fetch_array($rsResult)) {
			$mediaItem = array();
			$mediaItem['media_id'] = $mediaRow['media_id'];
			$mediaItem['media'] = $mediaRow['media'];
			$mediaItem['type'] = $this->getMediaType($mediaRow['media']);
			array_push($returnData->data, $mediaItem);
		}
		
		NetDebug::trace($rsResult);
		//reset($rsResult);
		return $returnData;
	}
	
	/**
     * Fetch the valid file extensions
     * @returns the items
     */
	public function getValidAudioExtensions()
	{
		return new returnData(0, $this->validAudioTypes);
	}
	
	/**
     * Fetch the valid file extensions
     * @returns the items
     */
	public function getValidVideoExtensions()
	{
		return new returnData(0, $this->validVideoTypes);
	}

	/**
     * Fetch the valid file extensions
     * @returns the items
     */
	public function getValidImageExtensions()
	{
		return new returnData(0, $this->validImageTypes);
	}

		
	
	/**
     * Create a media record
     * @returns the new mediaID on success
     */
	public function createMedia($intGameID, $strFileName)
	{
		
		$prefix = $this->getPrefix($intGameID);
		if (!$prefix) return new returnData(1, NULL, "invalid game id");
		
            	
		$query = "INSERT INTO {$prefix}_media 
					(media)
					VALUES ('{$strFileName}')";
		
		NetDebug::trace("Running a query = $query");	
		
		@mysql_query($query);
		if (mysql_error()) return new returnData(3, NULL, "SQL Error");
		
		return new returnData(0, mysql_insert_id());


	}

	
	
	/**
     * Update a specific Item
     * @returns true if edit was done, false if no changes were made
     */
	public function updateMedia($intGameID, $intMediaID, $strFileName)
	{
		$prefix = $this->getPrefix($intGameID);
		if (!$prefix) return new returnData(1, NULL, "invalid game id");

		//TODO: Delete the old file

		$query = "UPDATE {$prefix}_media  
					SET media = '{$strFileName}'
					WHERE media_id = '{$intMediaID}'";
		
		NetDebug::trace("updateNpc: Running a query = $query");	
		
		@mysql_query($query);
		if (mysql_error()) return new returnData(3, NULL, "SQL Error");
		
		if (mysql_affected_rows()) return new returnData(0, TRUE);
		else return new returnData(0, FALSE);
		

	}
			
	
	/**
     * Delete a Media Item
     * @returns true if delete was done, false if no changes were made
     */
	public function deleteMedia($intGameID, $intMediaID)
	{
		$prefix = $this->getPrefix($intGameID);
		if (!$prefix) return new returnData(1, NULL, "invalid game id");
		
		
		//TODO: Delete the old file

		
		$query = "DELETE FROM {$prefix}_media WHERE media_id = {$intMediaID}";
		
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
	* @returns path to the media directory on the file system
	*/
	public function getMediaDirectory($prefix){
		return new returnData(0, Config::engineSitesPath . "/{$prefix}/Templates/Default/templates");
	}
	
	/**
	* @returns path to the media directory URL
	*/
	public function getMediaDirectoryURL($prefix){
		return new returnData(0, Config::engineWWWPath . "/{$prefix}/Templates/Default/templates");
	}	
	
	/**
     * Fetch the prefix of a game
     * @returns a prefix string without the trailing _
     */
	public function getPrefix($intGameID) {
		//Lookup game information
		$query = "SELECT * FROM games WHERE game_id = '{$intGameID}'";
		$rsResult = mysql_query($query);
		if (mysql_num_rows($rsResult) < 1) return FALSE;
		$gameRecord = mysql_fetch_array($rsResult);
		return substr($gameRecord['prefix'],0,strlen($row['prefix'])-1);
		
	}
	
	/**
     * Determine the Item Type
     * @returns "Audio", "Video" or "Image"
     */
	private function getMediaType($strMediaFileName) {
		$mediaParts = pathinfo($strMediaFileName);
 		$mediaExtension = $mediaParts['extension'];
 		
 		if (in_array($mediaExtension, $this->validImageTypes )) return 'Image';
 		else if (in_array($mediaExtension, $this->validAudioTypes )) return 'Audio';
		else if (in_array($mediaExtension, $this->validVideoTypes )) return'Video';
 		
 		return FALSE;
 		
 	}
	
}