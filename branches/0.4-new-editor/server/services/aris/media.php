<?php
require("module.php");


class Media extends Module
{
		

	/**
     * Fetch all Media
     * @returns the media
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
     * @returns the extensions
     */
	public function getValidAudioExtensions()
	{
		return new returnData(0, $this->validAudioTypes);
	}
	
	/**
     * Fetch the valid file extensions
     * @returns the extensions
     */
	public function getValidVideoExtensions()
	{
		return new returnData(0, $this->validVideoTypes);
	}

	/**
     * Fetch the valid file extensions
     * @returns the extensions
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
		
		NetDebug::trace("Filename: $strFileName");	
            	
		$query = "INSERT INTO {$prefix}_media 
					(media)
					VALUES ('{$strFileName}')";
		
		NetDebug::trace("Running a query = $query");	
		
		@mysql_query($query);
		if (mysql_error()) return new returnData(3, NULL, "SQL Error");
		
		return new returnData(0, mysql_insert_id());
	}

	
	
	/**
     * Update a specific Media
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
		return new returnData(0, Config::gamedataFSPath . "/{$prefix}/" . Config::gameMediaSubdir);
	}
	
	/**
	* @returns path to the media directory URL
	*/
	public function getMediaDirectoryURL($prefix){
		return new returnData(0, Config::gamedataFSPath . "/{$prefix}/". Config::gameMediaSubdir);
	}	

	
}