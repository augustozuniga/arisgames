<?php	
	
include_once('common.inc.php');
print_header('Create a new ARIS Game');
	//Navigation
	echo "<div class = 'nav'>
	<a href = 'index.php'>Back to Game Selection</a>
	<a href = 'logout.php'>Logout</a>
	</div>";
	
if (isSet($_REQUEST['short']) and isSet($_REQUEST['name'])) {
		
	$new_game_short = $_REQUEST['short'];
	$new_game_name = $_REQUEST['name'];	

	//Check if a game with this prefix has already been created
	$query = "SELECT * FROM games WHERE prefix = '{$new_game_short}_'";
	if( mysql_num_rows(mysql_query($query)) > 0) die ('That game name has already been taken');

		
		
	echo '<p>Trying to create the game folder:';
	echo exec("cp -R -v -n {$engine_sites_path}/{$default_site} {$engine_sites_path}/{$new_game_short}");
	echo '</p>';

	$phpFile = "{$engine_sites_path}/{$new_game_short}.php";
	$file_handle = fopen($phpFile, 'w') or die("Can't open file");

	$file_data = 
	"<?php

	/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

	/**
	* Framework_Site_Aris
	*
	* @author      Joe Stump <joe@joestump.net>
	* @copyright   Joe Stump <joe@joestump.net>
	* @package     Framework
	* @filesource
	*/

	/**
	* Framework_Site_Aris
	*
	* Framework allows you to run multiple sites with multiple templates and
	* modules. Each site needs it's own site driver. You can use this to house
	* centrally located/needed information and such.
	*
	* @author      Kevin Harris <joe@joestump.net>
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

	fwrite($file_handle, $file_data);
	fclose($file_handle);

	/*
	This returns a really messy string full of bad characters that freak things out
	Let's get to this later

	$xml_file = "{$engine_sites_path}/{$new_game_short}/config.xml";
	$xml_contents = urlencode(file_get_contents($xml_file));
	echo $xml_contents;
	*/


	//Create the game record in SQL
	$query = "INSERT INTO games (prefix,name) VALUES ('{$new_game_short}_','{$new_game_name}')";
	mysql_query($query);
	$game_id = mysql_insert_id();

	//Make the creator an editor of the game
	$query = "INSERT INTO game_editors (game_id,editor_id) VALUES ('$game_id','{$_SESSION[user_id]}')";
	mysql_query($query);

	//Create the SQL tables

	$query = "
		CREATE TABLE {$new_game_short}_applications (
		application_id int(10) unsigned NOT NULL auto_increment,
		name varchar(25) default NULL,
		directory varchar(25) default NULL,
		PRIMARY KEY  (application_id)
		)";
	mysql_query($query);
	echo mysql_error();

	
	//Insert default data into the new game applicaiton table
	$query = "INSERT INTO {$new_game_short}_applications (application_id, name, directory) VALUES (2, 'GPS', 'Map')";
	mysql_query($query);
	echo mysql_error();
	
	$query = "INSERT INTO {$new_game_short}_applications (application_id, name, directory) VALUES 	(3, 'IM', 'NodeViewer')";
	mysql_query($query);
	echo mysql_error();

	$query = "INSERT INTO {$new_game_short}_applications (application_id, name, directory) VALUES 	(4, 'To Do', 'Quest')";
	mysql_query($query);
	echo mysql_error();

	$query = "INSERT INTO {$new_game_short}_applications (application_id, name, directory) VALUES 	(5, 'Files', 'Inventory')";
	mysql_query($query);
	echo mysql_error();

	$query = "INSERT INTO {$new_game_short}_applications (application_id, name, directory) VALUES 	(6, 'Logout', 'logout')";
	mysql_query($query);
	echo mysql_error();


	$query = "
		CREATE TABLE {$new_game_short}_events (
		event_id int(10) unsigned NOT NULL auto_increment,
		description tinytext COMMENT 'This description is not used anywhere in the game. It is simply for reference.',
		PRIMARY KEY  (event_id)
		)";
	mysql_query($query);
	echo mysql_error();

	$query = "CREATE TABLE {$new_game_short}_items (
		item_id int(11) unsigned NOT NULL auto_increment,
		name varchar(25) default NULL,
		description text,
		media varchar(50) NOT NULL default 'item_default.jpg',
		PRIMARY KEY  (item_id)
		) ";
	mysql_query($query);
	echo mysql_error();

	$query = "CREATE TABLE {$new_game_short}_locations (
		location_id int(11) NOT NULL auto_increment,
		media varchar(30) default NULL,
		name varchar(50) default NULL,
		description tinytext,
		latitude double default '43.0746561',
		longitude double default '-89.384422',
		error double default '0.0005',												
		type enum('Node','Event','Item','Npc') default NULL,
		type_id int(11) default NULL,
		require_event_id int(10) unsigned default NULL,
		remove_if_event_id int(10) unsigned default NULL,
		add_event_id int(10) unsigned default NULL,
		PRIMARY KEY  (location_id),
		KEY require_event_id (require_event_id)
		)";
	mysql_query($query);
	echo mysql_error();


	$query = "CREATE TABLE {$new_game_short}_log (
		   log_id int(11) unsigned NOT NULL auto_increment,
		   name tinytext,
		   description text,
		   text_when_complete tinytext NOT NULL COMMENT 'This is the txt that displays on the completed quests screen',
		   media varchar(50) default 'quest_default.jpg',
		   require_event_id int(11) unsigned default NULL,
		   add_event_id int(10) unsigned default NULL,
		   complete_if_event_id int(10) unsigned default NULL COMMENT 'If the specified event is present, this quest will move to the completed quests area',
		   PRIMARY KEY  (log_id),
		   KEY require_event_id (require_event_id),
		   KEY complete_if_event_id (complete_if_event_id)
			)";
	mysql_query($query);
	echo mysql_error();

	$query = "CREATE TABLE {$new_game_short}_nodes (
		 node_id int(11) unsigned NOT NULL auto_increment,
		 force_layout varchar(20) default NULL,
		 title varchar(100) default NULL,
		 text text,
		 opt1_text varchar(100) default NULL,
		 opt1_node_id int(11) unsigned default NULL,
		 opt2_text varchar(100) default NULL,
		 opt2_node_id int(11) unsigned default NULL,
		 opt3_text varchar(100) default NULL,
		 opt3_node_id int(11) unsigned default NULL,
		 add_item_id int(11) unsigned default NULL,
		 remove_item_id int(11) unsigned default NULL,
		 require_item_id int(11) unsigned default NULL,
		 required_condition_not_met_node_id int(11) unsigned default NULL COMMENT 'If an item, event or string is required but the player doesn''t have it, go to this node',
		 add_event_id int(11) unsigned default NULL,
		 remove_event_id int(11) unsigned default NULL,
		 require_event_id int(10) unsigned default NULL,
		 require_answer_string varchar(50) default NULL,
		 require_answer_correct_node_id int(10) unsigned default NULL,
		 require_location_id int(10) unsigned default NULL,
		 media varchar(25) default 'mc_chat_icon.png',
		 PRIMARY KEY  (node_id),
		 KEY require_event_id (require_event_id)
		)";
	mysql_query($query);
	echo mysql_error();

	$query = "CREATE TABLE {$new_game_short}_npc_conversations (
		 conversation_id int(11) NOT NULL auto_increment,
		npc_id int(10) unsigned NOT NULL default '0',
		 node_id int(10) unsigned NOT NULL default '0',
		 text tinytext NOT NULL,
		 require_event_id int(10) unsigned default NULL,
		 require_item_id int(10) unsigned default NULL,
		 require_location_id int(10) unsigned default NULL,
		 remove_if_event_id int(9) default NULL,
		 PRIMARY KEY  (conversation_id)
		)";
	mysql_query($query);
	echo mysql_error();

	$query = "CREATE TABLE {$new_game_short}_npcs (
		npc_id int(10) unsigned NOT NULL auto_increment,
		name varchar(30) NOT NULL default '',
		description tinytext,
		text tinytext,
		location_id int(10) unsigned default NULL,
		media varchar(30) default NULL,
		require_event_id mediumint(9) default NULL,
		PRIMARY KEY  (npc_id)
		)";
	mysql_query($query);
	echo mysql_error();

	$query = "CREATE TABLE {$new_game_short}_player_applications (
		id int(11) NOT NULL auto_increment,
		player_id int(10) unsigned NOT NULL default '0',
		application_id int(10) unsigned NOT NULL default '0',
		PRIMARY KEY  (id)
		) ";
	mysql_query($query);
	echo mysql_error();

	$query = "CREATE TABLE {$new_game_short}_player_events (
		id int(11) NOT NULL auto_increment,
		player_id int(10) unsigned NOT NULL default '0',
		event_id int(10) unsigned NOT NULL default '0',
		timestamp timestamp NOT NULL default CURRENT_TIMESTAMP,
		PRIMARY KEY  (id)
		)";
	mysql_query($query);
	echo mysql_error();

	$query = "CREATE TABLE {$new_game_short}_player_items (
		id int(11) NOT NULL auto_increment,
		player_id int(11) unsigned NOT NULL default '0',
		item_id int(11) unsigned NOT NULL default '0',
		timestamp timestamp NOT NULL default CURRENT_TIMESTAMP,
		PRIMARY KEY  (id),
		KEY player_id (player_id),
		KEY item_id (item_id)
		)";
	mysql_query($query);
	echo mysql_error();


	echo "<h3>This script has:</h3>
		<li>Created a site php and directory</li>
		<li>added the game to the games table</li>
		<li>made you an editor</li>
		<li>Created appropiate tables for your new game</ll>
		<h3>You still need to go edit: {$engine_sites_path}/{$new_game_short}/config.xml manually </h3>";

}
else {
	$form = "<form action = '{$_SERVER['PHP_SELF']}' method = 'get'>
			<table>
				<tr><td>Full Game Name</td><td><input type = 'text' name = 'name'/></td></tr>
				<tr><td>Short version (No spaces allowed)</td><td><input type = 'text' name = 'short'/></td></tr>
				<tr><td>&nbsp;</td><td><input type = 'submit'/></td></tr>
			</table>
			</form>";
	echo $form;

}
	
?>
