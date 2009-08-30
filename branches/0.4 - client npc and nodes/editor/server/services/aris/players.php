<?php
require("module.php");


class Players extends Module
{	

	/**
     * Login
     * @returns player id
     */
	public function login($strUser,$strPassword)
	{

		$query = "SELECT * FROM players 
				WHERE user_name = '{$strUser}' and password = '{$strPassword}' LIMIT 1";
		
		//NetDebug::trace($query);

		$rs = @mysql_query($query);
		if (mysql_num_rows($rs) < 1) return new returnData(4, NULL, 'bad username or password');
		
		$editor = @mysql_fetch_array($rs);
		return new returnData(0, intval($editor['player_id']));
	}
		

	/**
     * getPlayersForGame
     * @returns players with this game id
     */
	public function getPlayersForGame($intGameID)
	{
		$prefix = $this->getPrefix($intGameID);
		if (!$prefix) return new returnData(1, NULL, "invalid game id");
		
		$query = "SELECT player_id, user_name, latitude, longitude FROM players 
				WHERE site = '{$prefix}'";
		
		//NetDebug::trace($query);

		$rs = @mysql_query($query);
		return new returnData(0, $rs);
	}



	/**
     * updates the lat/long for the player record
     * @returns players with this game id
     */
	public function updatePlayerLocation($intPlayerID, $floatLat, $floatLong)
	{
		$query = "UPDATE players
					SET latitude = {$floatLat} , longitude = {$floatLong}
					WHERE player_id = {$intPlayerID}";
		
		NetDebug::trace($query);

		@mysql_query($query);
		
		if (mysql_error()) return new returnData(3, NULL, "SQL Error");
		if (mysql_affected_rows()) return new returnData(0, TRUE);
		else return new returnData(0, FALSE);
	}
	
	/**
     * New Player
     * @returns player id
     */
	public function createPlayer($strUser, $strPassword, $strFirstName, $strLastName, $strEmail)
	{
		return new returnData(4, NULL, 'not yet implemented');
	}
	
	
	
}
?>