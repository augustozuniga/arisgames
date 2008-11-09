<?php	
	
include_once('common.inc.php');
print_header('Create a new ARIS Game');
	//Navigation
	echo "<div class = 'nav'>
	<a href = 'index.php'>Back to Game Selection</a>
	<a href = 'logout.php'>Logout</a>
	</div>";
	
if (isSet($_REQUEST['short']) and isSet($_REQUEST['name'])) {
		
	if (empty($_REQUEST['short'])) {
		displayForm('Please enter a short name.', $_REQUEST['short'], $_REQUEST['name']);
		die;
	}
	else if (empty($_REQUEST['name'])) {
		displayForm('Please enter a full game name.', $_REQUEST['short'], $_REQUEST['name']);
		die;
	}
		
	$new_game_short = $_REQUEST['short'];
	$new_game_name = addslashes($_REQUEST['name']);	

	//Check if a game with this prefix has already been created
	$query = "SELECT * FROM games WHERE prefix = '{$new_game_short}_'";
	if( mysql_num_rows(mysql_query($query)) > 0) die ('That game name has already been taken');

		
	//Copy the default site to the new name	
	echo '<p>Creating Game files</p>';
	$from = "{$engine_sites_path}/{$default_site}";
	$to = "{$engine_sites_path}/{$new_game_short}";
	exec("cp -R -v -n $from $to", $output, $return);
	if ($return) die ("<h3>There was an error copying the default site into a new game directory</h3>
					  <p>From: {$from}</p>
					  <p>To: {$to}</p>
					  <p>Check your config file paths and that the Site directory is writable by the web server user<p>");
	else echo "<p>Compressed Files</p>";

	
	//Build XML file
	echo '<p>Creating config.xml</p>';
	$file_data = '<?xml version="1.0" ?>
<!--

Each Framework_Site must have a config.xml. This is loaded up by Framework_Site
and can be accessed via Framework::$site->config. Feel free to add your own
configuration stuff here.

-->
<framework>
	<db>
	<type>MySQL</type>
	<dsn>mysql:dbname=aris;host=localhost;username=arisuser;password=arispwd</dsn>
	</db>

<!-- 
This MUST be readable/writeable by your web servers user (this is
normally nobody/nogroup or www-data/www-data).
-->
<logFile>/tmp/framework.log</logFile>

<!--
app				-	The name of the ARIS application
company			-	The "company" that created the application
techEmail		-	The email address of technical support/help 
tablePrefix		-	The tables to use in SQL
-->
<aris>
	<app>ARIS</app>
	<company>ARIS</company>
	<techEmail>techsupport@gmail.com</techEmail>
	<tablePrefix>' . $new_game_short . '_</tablePrefix>
	
	<main>
		<title>Player %s</title>
		<body>Welcome to ARIS</body>
		<defaultModule>Main</defaultModule>
	</main>
	
	<nodeViewer>
		<title>Contact List</title>
	</nodeViewer>
	
	<map>
		<!--ABQIAAAAaBINj42Tz4K8ZaoZWWSnWRT2yXp_ZAY8_ufC3CFXhHIE1NvwkxQkcVoUCrdum-UscUMoKinDrDjThQ is for localhost-->
		<!--ABQIAAAAKdhUzwbl5RsEXD6h2Ua_HRQsvlSBtAWfm4N2P3iTGfWOp-UrmRRwG9t9N2_fCbAVKXjr59p56Fx_zA is for atsosxdev-->
		<!--ABQIAAAAKdhUzwbl5RsEXD6h2Ua_HRRloMOfjiI7F4SM41AgXh_4cb6l9xTntP3tXw4zMbRaLS6TOMA3-jBOlw is for arisgames.org-->
		<googleKey>' . $google_key . '</googleKey>
		<width>320</width>
		<height>200</height>
		<error>0.0005</error>
		<playerColor>yellow</playerColor>
	</map>
	
	<quest>
		<title>Quests</title>
	</quest>
	
	<inventory>
		<title>Inventory</title>
		<imageIcon>defaultImageIcon.png</imageIcon>
		<videoIcon>defaultVideoIcon.png</videoIcon>
		<audioIcon>defaultAudioIcon.png</audioIcon>
		<pdfIcon>defaultPdfIcon.png</pdfIcon>
	</inventory>
	
	<async>
		<notification>Signal lost.</notification>
	</async>

	<developer>
		<title>Developer</title>
	</developer>

</aris>

<!--
userTable       -   The users table to draw user data from 
userField       -   The primary key for userTable
defaultUser     -   Create a dummy record and put its primary key here
-->

<user>
	<userTable>players</userTable>
	<userField>player_id</userField> 
	<defaultUser>0</defaultUser>
</user>

</framework>';
	
	$xmlFile = "{$engine_sites_path}/{$new_game_short}/Config.xml";
	$file_handle = fopen($xmlFile, 'w') or die("Can't open file");
	fwrite($file_handle, $file_data);
	fclose($file_handle);
	
	
	//Build PHP file
	echo "<p>Creating {$new_game_short}.xml</p>";
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
	
	$phpFile = "{$engine_sites_path}/{$new_game_short}.php";
	$file_handle = fopen($phpFile, 'w') or die("Can't open file");
	fwrite($file_handle, $file_data);
	fclose($file_handle);


	echo '<p>Creating a record for this game in the editor</p>';
	//Create the game record in SQL
	$query = "INSERT INTO games (prefix,name) VALUES ('{$new_game_short}_','{$new_game_name}')";
	mysql_query($query);
	echo mysql_error();
	$game_id = mysql_insert_id();


	echo '<p>Granting your user editing rights for the new game</p>';
	//Make the creator an editor of the game
	$query = "INSERT INTO game_editors (game_id,editor_id) VALUES ('$game_id','{$_SESSION[user_id]}')";
	mysql_query($query);
	echo mysql_error();



	echo '<p>Constructing default data for the new game in SQL</p>';
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


	$query = "INSERT INTO {$new_game_short}_applications (application_id, name, directory) VALUES 	(7, 'Dev', 'Developer')";
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
		UNIQUE KEY `unique` (`player_id`,`event_id`),
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
		KEY item_id (item_id),
		UNIQUE KEY `unique` (`player_id`,`item_id`)
		)";
	mysql_query($query);
	echo mysql_error();

	//Create a test player for this game and give them all applications
	echo "<p>Creating a test player for this game and give them default applicaitons</p>";
	$query = "INSERT INTO players (first_name,last_name,user_name,password,site) 
				VALUES 	('{$new_game_short}', 'Tester', '{$new_game_short}', '{$new_game_short}','{$new_game_short}')";
	mysql_query($query);
	echo mysql_error();
	$test_player_id = mysql_insert_id();

	$query = "SELECT * FROM {$new_game_short}_applications";
	$result = mysql_query($query);
	echo mysql_error();
	while ($application = mysql_fetch_array($result)) {
			$new_player_application_query = "INSERT INTO {$new_game_short}_player_applications (player_id,application_id)
			VALUES ('{$test_player_id}','{$application['application_id']}')";
			mysql_query($new_player_application_query);
			echo mysql_error();
	}




	echo "<h3>Game Created!</h3>
		<h3>&nbsp;</h3>
		<h3>Test player login info:</h3> 
		<p>username: {$new_game_short} </p>
		<p>password: {$new_game_short} </p>";

}
else displayForm();

function displayForm($msg = '', $short = '', $long = '') {
	$form = "<form action = '{$_SERVER['PHP_SELF']}' method = 'get'>
			<table>
				<tr><td style='color: red;'>$msg</td><td></td></tr>
				<tr><td>Full Game Name</td><td><input type = 'text' name = 'name' value='$long' /></td></tr>
				<tr><td>Short version (No spaces allowed)</td><td><input type = 'text' name = 'short' value='$short'/></td></tr>
				<tr><td>&nbsp;</td><td><input type = 'submit'/></td></tr>
			</table>
			</form>";
	echo $form;
}
	
?>
