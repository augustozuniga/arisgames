<?php
include('config.class.php');
include('returnData.class.php');

class Games 
{	
	
	public function Games()
	{
		$this->conn = mysql_pconnect(Config::dbHost, Config::dbUser, Config::dbPass);
      	mysql_select_db (Config::dbSchema);
	}
	
	
	/**
     * Fetch the games an editor may edit
     * @returns Object Recordset for each Game.
     */
	public function getGames($intEditorID)
	{
		$query = "SELECT super_admin FROM editors 
				WHERE editor_id = '$intEditorID' LIMIT 1";
		$editor = mysql_fetch_array(mysql_query($query));
		
		if ($editor['super_admin'] == 1)  {
		       NetDebug::trace("getGames: User is super admin, load all games");
		       $query = "SELECT * FROM games";
		       NetDebug::trace($query);

        }
        else {
            NetDebug::trace("getGames: User is NOT a super admin");

            $query = "SELECT FROM games 
				JOIN game_editors 
				ON (games.game_id = game_editors.game_id)
				WHERE game_editors.editor_id = '$intEditorID'";
			NetDebug::trace($query);
	    }
		
		$rs = @mysql_query($query);
		if (mysql_error())  return new returnData(3, NULL, 'SQL error');

		return new returnData(0, $rs, NULL);		

	}
	
	
	/**
     * Create a new game
     * @returns an integer of the newly created game_id
     */	
	public function createGame($intEditorID, $strFullName)
	{

		$strFullName = addslashes($strFullName);	
        
                
		//Check if a game with this name has already been created
		$query = "SELECT * FROM games WHERE name = '{$strFullName}'";
		NetDebug::trace($query);
		if (mysql_num_rows(mysql_query($query)) > 0) 
		    return new returnData(4, NULL, 'duplicate name');
		
		
		//Create the game record in SQL
		$query = "INSERT INTO games (name) VALUES ('{$strFullName}')";
		@mysql_query($query);
		if (mysql_error())  return new returnData(6, NULL, 'cannot create game record');
		$newGameID = mysql_insert_id();
	    $strShortName = mysql_insert_id();
	
	
	    //HACK: We should change the engine to look at the game_id, but for now we will just set the
	    //short name to the new game id
	    $query = "UPDATE games SET prefix = '{$strShortName}_' WHERE game_id = '{$newGameID}'";
		@mysql_query($query);
		if (mysql_error())  return new returnData(6, NULL, 'cannot update game record');
		
	
		//Make the creator an editor of the game
		$query = "INSERT INTO game_editors (game_id,editor_id) VALUES ('{$newGameID}','{$intEditorID}')";
		@mysql_query($query);
		if (mysql_error()) return new returnData(6, NULL, 'cannot create game_editors record');
		
			
	

		//Copy the default site to the new name	
		$from = Config::engineSitesPath . '/' . Config::engineDefaultSite;
		$to = Config::engineSitesPath . "/{$strShortName}";
		$command = "cp -R -v -n $from $to";
		NetDebug::trace($command);
		exec($command, $output, $return);
		if ($return) return new returnData(5, NULL, 'cannot copy default site');

	
		
		//Build XML file
		$defaultConfigFile = Config::engineSitesPath . '/' . Config::engineDefaultSite . '/config.xml';
		if (!$defaultConfigHandle = fopen($defaultConfigFile, 'r'))  return new returnData(5, NULL, 'cannot open default config file'); 
		$defaultConfigContent = fread($defaultConfigHandle, filesize($defaultConfigFile));
		//$defaultConfigContent = str_replace("%tablePrefix%", $new_game_short . "_", $defaultConfigContent);
		fclose($defaultConfigHandle);



		$xmlFile = Config::engineSitesPath . "/{$strShortName}/config.xml";
		if(!$file_handle = fopen($xmlFile, 'w'))   return new returnData(5, NULL, 'cannot create XML file');
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
		
		
		$phpFile = Config::engineSitesPath . "/{$strShortName}.php";
		if (!$file_handle = fopen($phpFile, 'w')) return new returnData(5, NULL, 'cannot create PHP file');
		fwrite($file_handle, $file_data);
		fclose($file_handle);
	
	
		//Create the SQL tables

		$query = "CREATE TABLE {$strShortName}_items (
			item_id int(11) unsigned NOT NULL auto_increment,
			name varchar(100) default NULL,
			description text,
			media varchar(50) NOT NULL default 'item_default.jpg',
			type enum('AV','Image') NOT NULL default 'Image',
			PRIMARY KEY  (item_id)
			)";
		@mysql_query($query);
		if (mysql_error()) return new returnData(6, NULL, 'cannot create items table');
				
		$query = "CREATE TABLE {$strShortName}_events (
			event_id int(10) unsigned NOT NULL auto_increment,
  			description tinytext,
 			 PRIMARY KEY  (event_id)
			)";
		@mysql_query($query);
		if (mysql_error()) return new returnData(6, NULL, 'cannot create events table');
		
		
		$query = "CREATE TABLE {$strShortName}_player_state_changes (
			id int(10) unsigned NOT NULL auto_increment,
			content_type enum('Node','Item','Npc','Quest') NOT NULL,
			content_id int(10) unsigned NOT NULL,
			action enum('GIVE_ITEM','GIVE_EVENT','TAKE_ITEM') NOT NULL,
			action_detail int(10) unsigned NOT NULL,
			PRIMARY KEY  (id)
			)";
		@mysql_query($query);
		if (mysql_error()) return new returnData(6, NULL, 'cannot create player_state_changes table');
		
		
		
		$query = "CREATE TABLE {$strShortName}_requirements (
			requirement_id int(11) NOT NULL auto_increment,
			content_type enum('Node','Quest','Item','Npc','Location') NOT NULL,
			content_id int(10) unsigned NOT NULL,
			requirement enum('HAS_ITEM','HAS_EVENT','DOES_NOT_HAVE_ITEM','DOES_NOT_HAVE_EVENT') NOT NULL,
			requirement_detail int(11) NOT NULL,
			PRIMARY KEY  (requirement_id)
			)";
		@mysql_query($query);
		if (mysql_error()) return new returnData(6, NULL, 'cannot create requirments table');
		
	
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
		@mysql_query($query);
		if (mysql_error()) return new returnData(6, NULL, 'cannot create locations table');
	
		$query = "CREATE TABLE {$strShortName}_quests (
			  quest_id int(11) unsigned NOT NULL auto_increment,
			  `name` tinytext,
			  description text,
			  text_when_complete tinytext NOT NULL COMMENT 'This is the txt that displays on the completed quests screen',
			  media varchar(50) default 'quest_default.jpg',
			  PRIMARY KEY  (quest_id)
			)";
		@mysql_query($query);
		if (mysql_error()) return new returnData(6, NULL, 'cannot create quests table');
		
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
		@mysql_query($query);
		if (mysql_error()) return new returnData(6, NULL, 'cannot create nodes table');
		
		$query = "CREATE TABLE {$strShortName}_npc_conversations (
			conversation_id int(11) NOT NULL auto_increment,
			npc_id int(10) unsigned NOT NULL default '0',
			node_id int(10) unsigned NOT NULL default '0',
			`text` tinytext NOT NULL,
			PRIMARY KEY  (conversation_id)
			)";
		@mysql_query($query);
		if (mysql_error()) return new returnData(6, NULL, 'cannot create conversations table');
		
	
		$query = "CREATE TABLE {$strShortName}_npcs (
			npc_id int(10) unsigned NOT NULL auto_increment,
			`name` varchar(30) NOT NULL default '',
			description tinytext,
			`text` tinytext,
			media varchar(30) default NULL,
			PRIMARY KEY  (npc_id)
			)";
		@mysql_query($query);
		if (mysql_error()) return new returnData(6, NULL, 'cannot create npcs table');
		
		$query = "CREATE TABLE {$strShortName}_player_events (
			id int(11) NOT NULL auto_increment,
			player_id int(10) unsigned NOT NULL default '0',
			event_id int(10) unsigned NOT NULL default '0',
			`timestamp` timestamp NOT NULL default CURRENT_TIMESTAMP,
			PRIMARY KEY  (id),
			UNIQUE KEY `unique` (player_id,event_id)
			)";
		@mysql_query($query);
		if (mysql_error()) return new returnData(6, NULL, 'cannot create player_events table');
		
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
		@mysql_query($query);
		if (mysql_error()) return new returnData(6, NULL, 'cannot create player_items table');
		
	
		$query = "CREATE TABLE {$strShortName}_qrcodes (
			  qrcode_id int(11) NOT NULL auto_increment,
			  `type` enum('Node','Event','Item','Npc') NOT NULL,
			  type_id int(11) NOT NULL,
			  PRIMARY KEY  (qrcode_id)
			)";
		@mysql_query($query);
		if (mysql_error()) return new returnData(6, NULL, 'cannot create qrcodes table');							
		
		
		
		$query = "CREATE TABLE {$strShortName}_media (
            media_id INT UNSIGNED NOT NULL AUTO_INCREMENT ,
            media VARCHAR( 255 ) NOT NULL ,
            PRIMARY KEY ( media_id )
            )";
		@mysql_query($query);
		if (mysql_error()) return new returnData(6, NULL, 'cannot create qrcodes table');	
		
		

		return new returnData(0, $newGameID, NULL);

		
	}
	
	/**
     * Sets a game's name
     * @returns true if a record was updated, false otherwise
     */	
	public function setGameName($intGameID, $strNewGameName)
	{
	    $returnData = new returnData(0, mysql_query($query), NULL);

		$strNewGameName = addslashes($strNewGameName);	
	
		$query = "UPDATE games SET name = '{$strNewGameName}' WHERE game_id = {$intGameID}";
		mysql_query($query);
		if (mysql_error()) return new returnData(3, false, "SQL Error");
		
		if (mysql_affected_rows()) return new returnData(0, TRUE);
		else return new returnData(0, FALSE);		
		
	}		
	
	
	
	/**
     * Copy a game to a new game
     * Not yet implemented
     * @returns true on success
     */	
	public function copyGame($intSourceGameID, $strNewShortName, $strNewFullName)
	{
	    return new returnData(1, NULL, "Copy Game Not Implemented on Server");
	}	
	
	
	
	
	/**
     * Create a new game
     * @returns returnCode = 0 on success
     */	
	public function deleteGame($intGameID)
	{
		$returnData = new returnData(0, NULL, NULL);
		
		$prefix = $this->getPrefix($intGameID);
		if (!$prefix) return new returnData(1, NULL, "game does not exist");
	
		//Delete the files
		exec('rm -rf '. Config::engineSitesPath . "/{$prefix}", $output, $return);
		NetDebug::trace('rm -rf '. Config::engineSitesPath . "/{$prefix}");
		if ($return) return new returnData(4, NULL, "unable to delete game directory");
		
		echo exec('rm ' . Config::engineSitesPath . "/{$prefix}.php", $output, $return);
		if ($return) return new returnData(4, NULL, "unable to delete game php file");
		
		
		//Delete the editor_games record
		$query = "DELETE FROM game_editors WHERE game_id IN (SELECT game_id FROM games WHERE prefix = '{$prefix}_')";
		@mysql_query($query);
		if (mysql_error()) return new returnData(3, NULL, 'SQL Error');	
		
		
		//Delete the game record
		$query = "DELETE FROM games WHERE prefix = '{$prefix}_'";
		@mysql_query($query);
		if (mysql_error()) return new returnData(3, NULL, 'SQL Error');	


		//Fetch the table names for this game
		$query = "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='{$this->dbSchema}' AND TABLE_NAME LIKE '{$prefix}_%'";
		$result = mysql_query($query);
		if (mysql_error()) return new returnData(3, NULL, 'SQL Error');	

		
		//Delete all tables for this game
		while ($table = mysql_fetch_array($result)) {
			 $query = "DROP TABLE {$table['TABLE_NAME']}";
			 mysql_query($query);
			 if (mysql_error()) return new returnData(3, NULL, 'SQL Error');	

		}
		
		return new returnData(0);	
	}	
	
	
	
	
	
	/**
     * Creates a game archive package
     * @returns the path to the file
     */		
	public function backupGame($intGameID)
	{
	
		$prefix = $this->getPrefix($intGameID);
	    if (!$prefix) return new returnData(1, NULL, "invalid game id");

		
		$tmpDir = "{$prefix}_backup_" . date('Y_m_d');
		
		
		//Delete a previous backup with the same name
		$rmCommand = "rm -rf ". Config::engineSitesPath . "/Backups/{$tmpDir}";
		exec($rmCommand, $output, $return);
		if ($return) return new returnData(5, NULL, "cannot remove existing backup, check file permissions");
		
		//Set up a tmp directory
		$mkdirCommand = "mkdir ". Config::engineSitesPath . "/Backups/{$tmpDir}";
		exec($mkdirCommand, $output, $return);
		if ($return) return new returnData(5, NULL, "cannot create backup dir, check file permissions");
	
	
		//Create SQL File
		$sqlFile = 'database.sql';
		
		$getTablesCommand = Config::mysqlBinPath . "/mysql --user=" . Config::dbUser . " --password=". Config::dbPass ." -B --skip-column-names INFORMATION_SCHEMA -e \"SELECT TABLE_NAME FROM TABLES WHERE TABLE_SCHEMA='" .  Config::dbSchema . "' AND TABLE_NAME LIKE '{$prefix}_%'\"";
		
		exec($getTablesCommand, $output, $return);
		
		if ($output == 127) return new returnData(6, NULL, "cannot get tables, check mysql bin path in config");
		
		$tables = '';
		foreach ($output as $table) {
			$tables .= $table;
			$tables .= ' ';
		}
	
		
		$createSQLCommand = Config::mysqlBinPath ."/mysqldump -u " . Config::dbUser . " --password=" . Config::dbPass . " " . Config::dbSchema . " $tables > ". Config::engineSitesPath . "/Backups/{$tmpDir}/{$sqlFile}";
		//echo "<p>Running: $createSQLCommand </p>";
		exec($createSQLCommand, $output, $return);
		if ($return) return new returnData(6, NULL, "cannot create SQL, check mysql bin path in config");
		
		
		//Copy the site into the tmp directory
		$copyCommand = "cp ". Config::engineSitesPath . "/{$prefix}.php ". Config::engineSitesPath . "/Backups/{$tmpDir}";
		NetDebug::trace($copyCommand);
		exec($copyCommand, $output, $return);
		if ($return) return new returnData(5, NULL, "cannot copy php file to backup dir, check file permissions");
		
		$copyCommand = "cp -R ". Config::engineSitesPath . "/{$prefix} ". Config::engineSitesPath . "/Backups/{$tmpDir}/{$prefix}";
		//echo "<p>Running: $copyCommand </p>";
		exec($copyCommand, $output, $return);
		if ($return) return new returnData(5, NULL, "cannot copy game dir to backup dir, check file permissions");
		
		
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
		$newWd = Config::engineSitesPath . "/Backups";
		chdir($newWd);
		$createZipCommand = "tar -cf ". Config::engineSitesPath . "/Backups/{$zipFile} {$tmpDir}/";
		exec($createZipCommand, $output, $return);
		if ($return) return new returnData(7, NULL, "cannot compress backup dir, check that tar command is avaialbe");
		
		//Delete the Temp
		$rmCommand = "rm -rf ". Config::engineSitesPath . "/Backups/{$tmpDir}";
		exec($rmCommand, $output, $return);
		if ($return) return new returnData(5, NULL, "cannot delete backup dir, check file permissions");
				
		return new returnData(0, Config::engineWWWPath . "/Backups/{$zipFile}");		
	}	
	
	
	
	/**
     * Restore a game from a file
     * Not yet implemented
     * @returns the game ID of the newly created game
     */		
	public function restoreGame($file)
	{
	    return new returnData(4, NULL, "restore Game Not Implemented on Server");

	}
	
	
	
	
	/**
     * Retrieve all editors
     *
     * @returns a recordset of the editor records
     */		
	public function getEditors()
	{
		$query = "SELECT * FROM editors";
		$rsResult = @mysql_query($query);
		if (mysql_error()) return new returnData(3, NULL, 'SQL Error');
		return new returnData(0, $rsResult);
	}


	
	
	/**
     * Retrieve editors of a specifc game
     *
     * @returns a recordset of the editor records
     */	
	public function getGameEditors($intGameID)
	{
		$query = "SELECT * FROM editors LEFT JOIN game_editors ON (editors.editor_id = game_editors.editor_id) WHERE editor_id = {$intGameID}";
		$rsResult = mysql_query($query);
		if (mysql_error()) return new returnData(3, NULL, 'SQL Error');
		return new returnData(0, $rsResult);
	}
	



	
	/**
     * Add an editor to a game
     *
     * @returns true or an error string
     */	
	public function addEditorToGame($intEditorID, $intGameID)
	{
		$query = "INSERT INTO game_editors (editor_id, game_id) VALUES ('{$intEditorID}','{$intGameID}')";
		$rsResult = @mysql_query($query);
		
		if (mysql_errno() == 1062) return new returnData(4, NULL, 'duplicate');
		if (mysql_error()) return new returnData(3, NULL, 'sql error');
		
		return new returnData(0);	
	}	



	
	/**
     * Remove an editor from a game
     *
     * @returns true or an error string
     */		
	public function removeEditorFromGame($intEditorID, $intGameID)
	{
		$query = "DELETE FROM game_editors WHERE editor_id = '{$intEditorID}' AND game_id = '{$intGameID}'";
		$rsResult = mysql_query($query);
		if (mysql_error()) return new returnData(1, NULL, 'SQL Error');
		
		if (mysql_affected_rows()) return new returnData(0, TRUE);
        else return new returnData(0, FALSE);
	}


	
	
	/**
     * Fetch the prefix of a game
     * @returns a prefix string without the trailing _
     */
    private function getPrefix($intGameID) {
		//Lookup game information
		$query = "SELECT * FROM games WHERE game_id = '{$intGameID}'";
		$rsResult = mysql_query($query);
		if (mysql_num_rows($rsResult) < 1) return FALSE;
		$gameRecord = mysql_fetch_array($rsResult);
		return substr($gameRecord['prefix'],0,strlen($row['prefix'])-1);
		
	}
	
}
?>