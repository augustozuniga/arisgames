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
	$_SESSION['current_game_short_name'] = substr($row['prefix'],0,strlen($row['prefix']) -1);
	$_SESSION['current_game_name'] = $row['name'];
	
	//Navigation
	echo "<div class = 'nav'>
	<a href = 'index.php'>Select a Different Game</a>
	<a href = 'db_upgrades.php'>DB Upgrades</a>
	<a href = 'logout.php'>Logout</a>
	</div>";
	
	echo "<h3>Basic Options</h3>";
	echo "<table width = '75%'><tr><td>
			<table class = 'gametasks'>
				<tr><td><a href = 'locations.php'><img src = 'images/location_icon.png'/></a></td><td><a href = 'locations.php'>Locations</a></td></tr>
				<tr><td><a href = 'nodes.php'><img src = 'images/node_icon.png'/></a></td><td><a href = 'nodes.php'>Nodes</a></td></tr>
			</table>
		</td><td>
			<table class = 'gametasks'>
				<tr><td><a href = 'players.php'><img src = 'images/player_icon.png'/></a></td><td><a href = 'players.php'>Players</a></td></tr>		
				<tr><td><a href = 'items.php'><img src = 'images/item_icon.png'/></a></td><td><a href = 'items.php'>Items</a></td></tr>
			</table>
		</td></tr></table>";
	
	echo "<h3>Intermediate Options</h3>";
	echo "<table width = '107%'><tr><td>
				<table class = 'gametasks'>
					<tr><td><a href = 'npcs.php'><img src = 'images/npc_icon.png'/></a></td><td><a href = 'npcs.php'>NPCs</a></td></tr>
					<tr><td><a href = 'events.php'><img src = 'images/event_icon.png'/></a></td><td><a href = 'events.php'>Events</a></td></tr>
				</table>
		</td><td>
				<table class = 'gametasks'>
					<tr><td><a href = 'conversations.php'><img src = 'images/conversation_icon.png'/></a></td><td><a href = 'conversations.php'>NPC Conversations</a></td></tr>
					<tr><td><a href = 'quests.php'><img src = 'images/quest_icon.png'/></a></td><td><a href = 'quests.php'>Quests</a></td></tr>
				</table>
		</td></tr></table>";

	echo "<h3>Advanced Options</h3>";
	echo "<table width = '85%'><tr><td>
				<table class = 'gametasks'>
					<tr><td><a href = 'applications.php'><img src = 'images/node_icon.png'/></a></td><td><a href = 'applications.php'>Applications</a></td></tr>
				</table>
			</td><td>
				<table class = 'gametasks'>
					<tr><td><a href = 'games_edit_xml.php'><img src = 'images/node_icon.png'/></a></td><td><a href = 'games_edit_xml.php'>Edit XML Config</a></td></tr>
				</table>
		</td></tr></table>";
	
	print_footer();
	

	
?>