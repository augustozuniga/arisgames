<?php	
	
	include_once('common.inc.php');
	
	//Check for correct input
	if(!isset($_REQUEST['game_id']) and !isset($_SESSION['current_game_id'])) echo '<script language="javascript">window.location = \'index.php\';</script>';
	if(isset($_REQUEST['game_id'])) $_SESSION['current_game_id'] = $_REQUEST['game_id'];
	
	//Load Game Info
	$query = "SELECT * FROM games WHERE game_id = {$_SESSION['current_game_id']}";
	$result = mysql_query($query);
	$row=mysql_fetch_array($result);
	print_header($row['name']);
	$_SESSION['current_game_prefix'] = $row['prefix'];
	$_SESSION['current_game_name'] = $row['name'];
	
	//Navigation
	echo "<div class = 'nav'>
	<a href = 'index.php'>Select a Different Game</a>
	<a href = 'db_upgrades.php'>DB Upgrades</a>
	<a href = 'logout.php'>Logout</a>
	</div>";
	
	echo "<h3>Tasks for this game</h3>";
	echo "<table width = '100%'><tr><td>
		<table class = 'gametasks'>
			<tr><td><a href = 'locations.php'><img src = 'images/location_icon.png'/></a></td><td><a href = 'locations.php'>Locations</a></td></tr>
			<tr><td><a href = 'nodes.php'><img src = 'images/node_icon.png'/></a></td><td><a href = 'nodes.php'>Nodes</a></td></tr>
			<tr><td><a href = 'npcs.php'><img src = 'images/npc_icon.png'/></a></td><td><a href = 'npcs.php'>NPCs</a></td></tr>
		</table></td>
		<td><table>
			<table class = 'gametasks'>
			<tr><td><a href = 'players.php'><img src = 'images/player_icon.png'/></a></td><td><a href = 'players.php'>Players</a></td></tr>		
			<tr><td><a href = 'conversations.php'><img src = 'images/conversation_icon.png'/></a></td><td><a href = 'conversations.php'>NPC Conversations</a></td></tr>
			<tr><td><a href = 'quests.php'><img src = 'images/quest_icon.png'/></a></td><td><a href = 'quests.php'>Quests</a></td></tr>
		</td></tr></table></table>";
	
	print_footer();
	

	
?>