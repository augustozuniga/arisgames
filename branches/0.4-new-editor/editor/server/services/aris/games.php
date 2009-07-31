<?php

class Games 
{
	private $NAME 				= "Games";
	private $VERSION			= "0.0.1";
	
	
	private $dbUser				= 'arisuser';
	private $dbPass 			= 'arispwd';
	private $dbSchema 			= 'aris';
	private $dbHost 			= 'localhost';
	
	private $engineSitesPath	= '/Users/davidgagnon/Sites/engine/Framework/Site';
	private	$engineWWWPath		= 'http://davembp.local/engine/Framework/Site';
	private $engineDefaultSite	= 'Default';
	private $mysqlBinPath		= '/Applications/MAMP/Library/bin';
	
	public function Editor()
	{
	}
	
	
	/**
     * Fetch the games an editor may edit
     * @returns the set of games.
     */
	public function getGames($intEditorID)
	{
		
		$query = "SELECT * FROM games 
				LEFT JOIN game_editors 
				ON (games.game_id = game_editors.game_id)
				WHERE game_editors.editor_id = '$intEditorID'";
		$rsConnectionID = $this->open();
		
		$rsResult = mysql_db_query($this->dbSchema, $query, $rsConnectionID);
		
		if(!$rsResult)
		   return mysql_error($rsConnectionID);
	
		$this->close($rsConnectionID);
		return $rsResult;
	}
	
	
	/**
     * Create a new game
     * @returns an integer of the newly created game_id
     */	
	public function createGame($intEditorID, $strShortName, $strFullName)
	{
		$rsConnectionID = $this->open();

		$strFullName = addslashes($strFullName);	
	
		//Check if a game with this prefix has already been created
		$query = "SELECT * FROM games WHERE prefix = '{$strShortName}_'";
		if (mysql_num_rows(mysql_db_query($this->dbSchema, $query, $rsConnectionID)) > 0) 
			return 'ERROR: duplicate short name';
	

		//Copy the default site to the new name	
		$from = "{$this->engineSitesPath}/{$this->engineDefaultSite}";
		$to = "{$this->engineSitesPath}/{$strShortName}";
		exec("cp -R -v -n $from $to", $output, $return);
		if ($return) return "ERROR: cannot copy default site";
	
		
		//Build XML file
		$defaultConfigFile = "{$this->engineSitesPath}/{$this->engineDefaultSite}/config.xml";
		if (!$defaultConfigHandle = fopen($defaultConfigFile, 'r'))  return "ERROR: Can't open default config file";
		$defaultConfigContent = fread($defaultConfigHandle, filesize($defaultConfigFile));
		//$defaultConfigContent = str_replace("%tablePrefix%", $new_game_short . "_", $defaultConfigContent);
		fclose($defaultConfigHandle);



		$xmlFile = "{$this->engineSitesPath}/{$strShortName}/config.xml";
		if(!$file_handle = fopen($xmlFile, 'w')) return "ERROR: Can't create XML file";
		fwrite($file_handle, $defaultConfigContent);
		fclose($file_handle);
		
		//Build PHP file
		$file_data = 
		"<?php
	
		/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */
		/**
		* Framework_Site_Aris
		*
		* Framework allows you to run multiple sites with multiple templates and
		* modules. Each site needs it's own site driver. You can use this to house
		* centrally located/needed information and such.
		*
		* @author      Kevin Harris <klharris2@wisc.edu>
		* @author      David Gagnon <djgagnon@wisc.edu>
		* @copyright   Joe Stump <joe@joestump.net>
		* @package     Framework
		* @filesource
		*/
	
		class Framework_Site_{$new_game_short} extends Framework_Site_Common {
			/**
			* $name
			*
			* @access      public
			* @var         string      $name       Name of site driver
			*/
			
			public " . '$name' . " = '{$new_game_short}';
			
			/**
			* prepare
			*
			* This function is ran by Framework right after loading up the site
			* driver. It's a good place to put initialization type code that is
			* globally required throughout your site.
			*
			* @access      public
			* @return      mixed
			*/
			public function prepare(){}
		}
	
		?>";
		
		
		$phpFile = "{$this->engineSitesPath}/{$strShortName}.php";
		if (!$file_handle = fopen($phpFile, 'w')) return "Can't create PHP file";
		fwrite($file_handle, $file_data);
		fclose($file_handle);
	
	
		//Create the game record in SQL
		$query = "INSERT INTO games (prefix,name) VALUES ('{$strShortName}_','{$strFullName}')";
		@mysql_db_query($this->dbSchema, $query, $rsConnectionID);
		if (mysql_error()) return "ERROR: Cannot create game record";
		$newGameID = mysql_insert_id();
	
	
		//Make the creator an editor of the game
		$query = "INSERT INTO game_editors (game_id,editor_id) VALUES ('{$newGameID}','{$intEditorID}')";
		@mysql_db_query($this->dbSchema, $query, $rsConnectionID);
		if (mysql_error()) return "ERROR: Cannot create game_editors record";
	
	
		//Create the SQL tables

		$query = "CREATE TABLE {$strShortName}_items (
			item_id int(11) unsigned NOT NULL auto_increment,
			name varchar(100) default NULL,
			description text,
			media varchar(50) NOT NULL default 'item_default.jpg',
			type enum('AV','Image') NOT NULL default 'Image',
			PRIMARY KEY  (item_id)
			)";
		@mysql_db_query($this->dbSchema, $query, $rsConnectionID);
		if (mysql_error()) return "ERROR: Cannot create items table";
				
		$query = "CREATE TABLE {$strShortName}_events (
			event_id int(10) unsigned NOT NULL auto_increment,
  			description tinytext,
 			 PRIMARY KEY  (event_id)
			)";
		@mysql_db_query($this->dbSchema, $query, $rsConnectionID);
		if (mysql_error()) return "ERROR: Cannot create events table";		
		
		
		$query = "CREATE TABLE {$strShortName}_player_state_changes (
			id int(10) unsigned NOT NULL auto_increment,
			content_type enum('Node','Item','Npc') NOT NULL,
			content_id int(10) unsigned NOT NULL,
			action enum('GIVE_ITEM','GIVE_EVENT','TAKE_ITEM') NOT NULL,
			action_detail int(10) unsigned NOT NULL,
			PRIMARY KEY  (id)
			)";
		@mysql_db_query($this->dbSchema, $query, $rsConnectionID);
		if (mysql_error()) return "ERROR: Cannot create player_state_changes table";
		
		
		
		$query = "CREATE TABLE {$strShortName}_requirements (
			requirement_id int(11) NOT NULL auto_increment,
			content_type enum('Node','Quest','Item','Npc','Location') NOT NULL,
			content_id int(10) unsigned NOT NULL,
			requirement enum('HAS_ITEM','HAS_EVENT','DOES_NOT_HAVE_ITEM','DOES_NOT_HAVE_EVENT') NOT NULL,
			requirement_detail int(11) NOT NULL,
			PRIMARY KEY  (requirement_id)
			)";
		@mysql_db_query($this->dbSchema, $query, $rsConnectionID);
		if (mysql_error()) return "ERROR: Cannot create requirements table";				
		
		
	
		$query = "CREATE TABLE {$strShortName}_locations (
	  		location_id int(11) NOT NULL auto_increment,
 	 		icon varchar(30) default NULL,
			`name` varchar(50) default NULL,
			description tinytext,
			latitude double default '43.0746561',
			longitude double default '-89.384422',
			error double default '0.0005',
			`type` enum('Node','Event','Item','Npc') default NULL,
			type_id int(11) default NULL,
			item_qty int(11) default NULL,
			hidden enum('0','1') default '0',
			force_view enum('0','1') NOT NULL default '0' COMMENT 'Forces this Location to Display when nearby',
			PRIMARY KEY  (location_id)
			)";
		@mysql_db_query($this->dbSchema, $query, $rsConnectionID);
		if (mysql_error()) return "ERROR: Cannot create locations table";
	
	
		$query = "CREATE TABLE {$strShortName}_quests (
			  quest_id int(11) unsigned NOT NULL auto_increment,
			  `name` tinytext,
			  description text,
			  text_when_complete tinytext NOT NULL COMMENT 'This is the txt that displays on the completed quests screen',
			  media varchar(50) default 'quest_default.jpg',
			  PRIMARY KEY  (quest_id)
			)";
		@mysql_db_query($this->dbSchema, $query, $rsConnectionID);
		if (mysql_error()) return "ERROR: Cannot create quests table";
	
		$query = "CREATE TABLE {$strShortName}_nodes (
			  node_id int(11) unsigned NOT NULL auto_increment,
			  title varchar(100) default NULL,
			  `text` text,
			  opt1_text varchar(100) default NULL,
			  opt1_node_id int(11) unsigned default NULL,
			  opt2_text varchar(100) default NULL,
			  opt2_node_id int(11) unsigned default NULL,
			  opt3_text varchar(100) default NULL,
			  opt3_node_id int(11) unsigned default NULL,
			  require_answer_incorrect_node_id int(11) unsigned default NULL,
			  require_answer_string varchar(50) default NULL,
			  require_answer_correct_node_id int(10) unsigned default NULL,
			  media varchar(25),
			  PRIMARY KEY  (node_id)
			)";
		@mysql_db_query($this->dbSchema, $query, $rsConnectionID);
		if (mysql_error()) return "ERROR: Cannot create nodes table";
	
		$query = "CREATE TABLE {$strShortName}_npc_conversations (
			conversation_id int(11) NOT NULL auto_increment,
			npc_id int(10) unsigned NOT NULL default '0',
			node_id int(10) unsigned NOT NULL default '0',
			`text` tinytext NOT NULL,
			PRIMARY KEY  (conversation_id)
			)";
		@mysql_db_query($this->dbSchema, $query, $rsConnectionID);
		if (mysql_error()) return "ERROR: Cannot create npc conversations table";
	
		$query = "CREATE TABLE {$strShortName}_npcs (
			npc_id int(10) unsigned NOT NULL auto_increment,
			`name` varchar(30) NOT NULL default '',
			description tinytext,
			`text` tinytext,
			media varchar(30) default NULL,
			PRIMARY KEY  (npc_id)
			)";
		@mysql_db_query($this->dbSchema, $query, $rsConnectionID);
		if (mysql_error()) return "ERROR: Cannot create npcs table";
	
		$query = "CREATE TABLE {$strShortName}_player_events (
			id int(11) NOT NULL auto_increment,
			player_id int(10) unsigned NOT NULL default '0',
			event_id int(10) unsigned NOT NULL default '0',
			`timestamp` timestamp NOT NULL default CURRENT_TIMESTAMP,
			PRIMARY KEY  (id),
			UNIQUE KEY `unique` (player_id,event_id)
			)";
		@mysql_db_query($this->dbSchema, $query, $rsConnectionID);
		if (mysql_error()) return "ERROR: Cannot create player_events table";
	
		$query = "CREATE TABLE {$strShortName}_player_items (
			id int(11) NOT NULL auto_increment,
			player_id int(11) unsigned NOT NULL default '0',
			item_id int(11) unsigned NOT NULL default '0',
			`timestamp` timestamp NOT NULL default CURRENT_TIMESTAMP,
			PRIMARY KEY  (id),
			UNIQUE KEY `unique` (player_id,item_id),
			KEY player_id (player_id),
			KEY item_id (item_id)
			)";
		@mysql_db_query($this->dbSchema, $query, $rsConnectionID);
		if (mysql_error()) return "ERROR: Cannot create player_items table";
	
	
		$query = "CREATE TABLE {$strShortName}_qrcodes (
			  qrcode_id int(11) NOT NULL auto_increment,
			  `type` enum('Node','Event','Item','Npc') NOT NULL,
			  type_id int(11) NOT NULL,
			  PRIMARY KEY  (qrcode_id)
			)";
		@mysql_db_query($this->dbSchema, $query, $rsConnectionID);
		if (mysql_error()) return "ERROR: Cannot create qrcodes table";
								
				
				
		$this->close($rsConnectionID);		
		return $newGameID;
		
	}
	
	/**
     * Sets a game's name
     * @returns true on success
     */	
	public function setGameName($intGameID, $strNewGameName)
	{
		$rsConnectionID = $this->open();

		$strNewGameName = addslashes($strNewGameName);	
	
		$query = "UPDATE games SET name = '{$strNewGameName}' WHERE game_id = {$intGameID}";
		mysql_db_query($this->dbSchema, $query, $rsConnectionID);
		if (mysql_error()) return false;
		else return true;
		
		//$this->close($rsConnectionID);
		
	}		
	
	
	
	/**
     * Copy a game to a new game
     * Not yet implemented
     * @returns true on success
     */	
	public function copyGame($intSourceGameID, $strNewShortName, $strNewFullName)
	{
	}	
	
	
	
	
	/**
     * Create a new game
     * @returns true on success
     */	
	public function deleteGame($intGameID)
	{
		$rsConnectionID = $this->open();
		$prefix = $this->getPrefix($intGameID);
	
		//Delete the files
		exec("rm -rf {$this->engineSitesPath}/{$prefix}", $output, $return);
		//if ($return) return "ERROR: unable to delete game directory";
		
		echo exec("rm {$this->engineSitesPath}/{$prefix}.php", $output, $return);
		if ($return) return "ERROR: unable to delete game php file";	
		
		
		//Delete the editor_games record
		$query = "DELETE FROM game_editors WHERE game_id IN (SELECT game_id FROM games WHERE prefix = '{$prefix}_')";
		mysql_db_query($this->dbSchema, $query, $rsConnectionID);
		
		
		//Delete the game record
		$query = "DELETE FROM games WHERE prefix = '{$prefix}_'";
		mysql_db_query($this->dbSchema, $query, $rsConnectionID);

		//Fetch the table names for this game
		$query = "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='{$this->dbSchema}' AND TABLE_NAME LIKE '{$prefix}_%'";
		$result = mysql_db_query($this->dbSchema, $query, $rsConnectionID);
		while ($table = mysql_fetch_array($result)) {
			 $query = "DROP TABLE {$table['TABLE_NAME']}";
			 mysql_db_query($this->dbSchema, $query, $rsConnectionID);
		}
		
		$this->close($rsConnectionID);
		return true;		
	}	
	
	
	
	
	
	/**
     * Creates a game archive package
     * @returns the path to the file
     */		
	public function backupGame($intGameID)
	{
	
		$rsConnectionID = $this->open();
		$prefix = $this->getPrefix($intGameID);
		
		$tmpDir = "{$prefix}_backup_" . date('Y_m_d');
		
		
		//Delete a previous backup with the same name
		$rmCommand = "rm -rf {$this->engineSitesPath}/Backups/{$tmpDir}";
		exec($rmCommand, $output, $return);
		if ($return) return "ERROR: cannot remove existing backup";
		
		//Set up a tmp directory
		$mkdirCommand = "mkdir {$this->engineSitesPath}/Backups/{$tmpDir}";
		exec($mkdirCommand, $output, $return);
		if ($return) return "ERROR: cannot create backup directory";
	
	
		//Create SQL File
		$sqlFile = 'database.sql';
		
		$getTablesCommand = "{$this->mysqlBinPath}/mysql --user={$this->dbUser} --password={$this->dbPass} -B --skip-column-names INFORMATION_SCHEMA -e \"SELECT TABLE_NAME FROM TABLES WHERE TABLE_SCHEMA='{$this->dbSchema}' AND TABLE_NAME LIKE '{$prefix}_%'\"";
		
		exec($getTablesCommand, $output, $return);
		
		if ($output == 127) return "ERROR: cannot fetch table names. Check the mysql bin path";
		
		
		$tables = '';
		foreach ($output as $table) {
			$tables .= $table;
			$tables .= ' ';
		}
	
		
		$createSQLCommand = "{$this->mysqlBinPath}/mysqldump -u {$this->dbUser} --password={$this->dbPass} {$this->dbSchema} $tables > {$this->engineSitesPath}/Backups/{$tmpDir}/{$sqlFile}";
		//echo "<p>Running: $createSQLCommand </p>";
		exec($createSQLCommand, $output, $return);
		if ($return) return "ERROR: cannot dump sql data. Check the mysql bin path";
		
		
		//Copy the site into the tmp directory
		$copyCommand = "cp {$this->engineSitesPath}/{$prefix}.php {$this->engineSitesPath}/Backups/{$tmpDir}";
		exec($copyCommand, $output, $return);
		if ($return) return "ERROR: cannot copy game directory to the backup directory";	
		
		$copyCommand = "cp -R {$this->engineSitesPath}/{$prefix} {$this->engineSitesPath}/Backups/{$tmpDir}/{$prefix}";
		//echo "<p>Running: $copyCommand </p>";
		exec($copyCommand, $output, $return);
		if ($return) return "ERROR: cannot copy php file to the backup directory";	
		
		
		/*
		//Create a version file
		$versionCommand = "{$svn_bin_path}/svnversion {$engine_path} > {$engine_sites_path}/Backups/{$tmpDir}/version";
		echo "<p>Running: $versionCommand </p>";
		exec($versionCommand, $output, $return);
		if ($return) echo ("<h3>There was an error creating a version file: $return </h3>
						  <p>Check your svn_bin_path in the config file<p>");
		else echo "<p>Version Recorded</p>";
		*/
		
		
		//Zip up the whole directory
		$zipFile = "{$prefix}_backup_" . date('Y_m_d') . ".tar";
		$newWd = "{$this->engineSitesPath}/Backups";
		chdir($newWd);
		$createZipCommand = "tar -cf {$this->engineSitesPath}/Backups/{$zipFile} {$tmpDir}/";
		exec($createZipCommand, $output, $return);
		if ($return) return "ERROR: cannot compress directory";
		
		//Delete the Temp
		$rmCommand = "rm -rf {$this->engineSitesPath}/Backups/{$tmpDir}";
		exec($rmCommand, $output, $return);
		if ($return) return "ERROR: Cannot delete temp directory";
		
		$this->close($rsConnectionID);
		return "{$this->engineWWWPath}/Backups/{$zipFile}";	
		
	}	
	
	
	
	/**
     * Restore a game from a file
     * Not yet implemented
     * @returns the game ID of the newly created game
     */		
	public function restoreGame($file)
	{
	}
	
	
	
	
	/**
     * Retrieve all editors
     *
     * @returns a recordset of the editor records
     */		
	public function getEditors()
	{
		$rsConnectionID = $this->open();
		$query = "SELECT * FROM editors";
		$rsResult = mysql_db_query($this->dbSchema, $query, $rsConnectionID);
		return $rsResult;
		$this->close($rsConnectionID);

	}


	
	
	/**
     * Retrieve editors of a specifc game
     *
     * @returns a recordset of the editor records
     */	
	public function getGameEditors($intGameID)
	{
		$rsConnectionID = $this->open();
		$query = "SELECT * FROM editors LEFT JOIN game_editors ON (editors.editor_id = game_editors.editor_id) WHERE editor_id = {$intGameID}";
		$rsResult = mysql_db_query($this->dbSchema, $query, $rsConnectionID);
		return $rsResult;
		$this->close($rsConnectionID);

	}
	



	
	/**
     * Add an editor to a game
     *
     * @returns true or an error string
     */	
	public function addEditorToGame($intEditorID, $intGameID)
	{
		$rsConnectionID = $this->open();
		$query = "INSERT INTO game_editors (editor_id, game_id) VALUES ('{$intEditorID}','{$intGameID}')";
		$rsResult = mysql_db_query($this->dbSchema, $query, $rsConnectionID);
		return $rsResult;	
		$this->close($rsConnectionID);
	}	



	
	/**
     * Remove an editor from a game
     *
     * @returns true or an error string
     */		
	public function removeEditorFromGame($intEditorID, $intGameID)
	{
		$rsConnectionID = $this->open();
		$query = "DELETE FROM game_editors WHERE editor_id = '{$intEditorID}' AND game_id = '{$intGameID}'";
		$rsResult = mysql_db_query($this->dbSchema, $query, $rsConnectionID);
		return $rsResult;		
		$this->close($rsConnectionID);
	}


	
	
	/**
     * Fetch the prefix of a game
     * @returns a prefix string without the trailing _
     */
	private function getPrefix($intGameID) {
		//Lookup game information
		//Check if a game with this prefix has already been created
		$rsConnectionID = $this->open();
		
		$query = "SELECT * FROM games WHERE game_id = '{$intGameID}'";
		$rsResult = mysql_db_query($this->dbSchema, $query, $rsConnectionID);
		if (mysql_num_rows($rsResult) < 1) return 'ERROR: game id not found';
		$gameRecord = mysql_fetch_array($rsResult);
		return substr($gameRecord['prefix'],0,strlen($row['prefix'])-1);
		
		$this->close($rsConnectionID);
	}
	


	
	/**
     * Open the connection to the database.
     * @returns the connection id.
     */
	private function open() 
	{
   		$rsConnectionID = @mysql_connect($this->dbHost, $this->dbUser, $this->dbPass);
    	return $rsConnectionID;	
  	}


	
	/**
     * Close the connection to the database.
     * @returns a resource.
     */
  	private function close($rsConnectionID) 
	{
    	$res = @mysql_close($rsConnectionID);
    	return $res;
  	}


	
	/**
     * Class name.
     * @returns a string that reprezent class name.
     */
	public function getName()
	{
		return $this->NAME;
	}
	
	
	
	/**
     * Class version.
     * @returns a string that reprezent class version.
     */
	public function getVersion()
	{
		return $this->VERSION;
	}
}
?>