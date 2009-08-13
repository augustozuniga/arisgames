<?php
include('config.class.php');
include('returnData.class.php');

class Editors 
{
		
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

		$editor = @mysql_fetch_array(@mysql_query($query));
		if (!editor) new returnData(1, NULL);
		return new returnData(0, intval($editor['editor_id']));
	}
	
	
	/**
     * Create a new editor
     * @returns the new editorID or false if an account already exists
     */
	public function createEditor($strUser, $strPassword, $strEmail, $strComments)
	{	
		$query = "SELECT editor_id FROM editors 
				  WHERE name = '{$strUser}' LIMIT 1";
			
		if (mysql_fetch_array(mysql_query($query))) {
			return new returnData(1, NULL, 'user exists');
		}
		
		$query = "INSERT INTO editors (name, password, email, comments) 
				  VALUES ('{$strUser}',MD5('$strPassword'),'{$strEmail}','{$strComments}' )";
			
		@mysql_query($query);
		if (mysql_error()) return new returnData(1, NULL, 'SQL Error');
		
		return new returnData(0, mysql_insert_id());
	}
	
	
}