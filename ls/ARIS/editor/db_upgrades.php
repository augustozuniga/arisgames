<?php
	
include_once('common.inc.php');
	
	print_header("{$_SESSION['current_game_name']} Database Upgrades");
	
	echo "<div class = 'nav'>
	<a href = 'games.php'>Back to {$_SESSION['current_game_name']}</a>
	<a href = 'logout.php'>Logout</a>
	</div>";	
	
	
	$query = "alter table {$_SESSION['current_game_prefix']}npc_conversations 
	add conversation_id int not null auto_increment primary key";

	mysql_query($query);
	
	if (mysql_error() == "Duplicate column name 'conversation_id'")
		echo '<h3>Upgrade Not needed for npc_conversations</h3>';
	else echo '<h3>npc_conversations updated successfully</h3>';

?>