<?php
	
include_once('common.inc.php');
	
	print_header("{$_SESSION['current_game_name']} Database Upgrades");
	
	echo "<div class = 'nav'>
	<a href = 'games.php'>Back to {$_SESSION['current_game_name']}</a>
	<a href = 'logout.php'>Logout</a>
	</div>";	
	
	
	echo "<h3>Dropping dual primary key from npc_conversations</h3>";
	$query = "ALTER TABLE {$_SESSION['current_game_prefix']}npc_conversations DROP PRIMARY KEY";
	mysql_query($query);
	if (mysql_error() == "Incorrect table definition; there can be only one auto column and it must be defined as a key") echo 'Not Needed';
		else echo mysql_error();	
	
	echo "<h3>Adding conversation_id primary key to npc_conversations</h3>";
	$query = "alter table {$_SESSION['current_game_prefix']}npc_conversations 
	add conversation_id int not null auto_increment primary key";
	mysql_query($query);
	if (mysql_error() == "Duplicate column name 'conversation_id'") echo 'Not Needed';
	else echo mysql_error();	

	
	
	echo "<h3>Converting Lat/Long to doubles in Locations</h3>";
	$query = "ALTER TABLE {$_SESSION['current_game_prefix']}locations 
			MODIFY COLUMN latitude DOUBLE NOT NULL DEFAULT 0,
			MODIFY COLUMN longitude DOUBLE NOT NULL DEFAULT 0";
	mysql_query($query);

	

?>