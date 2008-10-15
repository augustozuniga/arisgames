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
	
	echo "<h3>Ensure Lat/Long are doubles in the Locations Table</h3>";
	$query = "ALTER TABLE {$_SESSION['current_game_prefix']}locations 
			MODIFY COLUMN latitude DOUBLE ,
			MODIFY COLUMN longitude DOUBLE ";
	mysql_query($query);

	echo "<h3>Add support for locations refering to items,npcs,nodes</h3>";
	$query ="ALTER TABLE {$_SESSION['current_game_prefix']}locations 
		ADD COLUMN type enum('Node','Event','Item','Npc') AFTER longitude,
		ADD COLUMN type_id INT AFTER type;";
	mysql_query($query);
	if (mysql_error() == "Duplicate column name 'type'") echo 'Not Needed';
	else echo mysql_error();	

	

?>