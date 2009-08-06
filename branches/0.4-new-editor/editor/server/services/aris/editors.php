<?php
include('config.class.php');

class Editors 
{
	private $NAME 				= "Editors";
	private $VERSION			= "0.0.1";
	
	
	public function Editors()
	{
		$this->conn = mysql_pconnect(Config::dbHost, Config::dbUser, Config::dbPass);
      	mysql_select_db (Config::dbSchema);
	}
	
	
	/**
     * Login to the editor
     * @returns the editorID
     */
	public function login($strUser, $strPassword)
	{
		
		$query = "SELECT * FROM editors 
				WHERE name = '$strUser' and password = MD5('{$strPassword}') LIMIT 1";
		
		NetDebug::trace($query);

		$editor = mysql_fetch_array(mysql_query($query));
	
		return $editor['editor_id'];
	}
	
	
	/**
     * Create a new editor
     * @returns the new editorID or false if an account already exists
     */
	public function createEditor($strUser, $strPassword)
	{	
		$query = "SELECT editor_id FROM editors 
				  WHERE name = '{$strUser}' LIMIT 1";
			
		if (mysql_fetch_array(mysql_query($query))) {
			NetDebug::trace('createEditor: user exists');
			return false;
		}
		
		$query = "INSERT INTO editors (name, password) 
				  VALUES ('{$strUser}',MD5('$strPassword'))";
			
		mysql_query($query);
		
		return mysql_insert_id();
	}
	
	
}