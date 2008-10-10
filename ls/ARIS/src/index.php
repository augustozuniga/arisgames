<?php	

	include_once('common.inc.php');

	//Clear Session variable for current game
	unset($_SESSION['current_game_prefix']);
	
	print_header('Your ARIS Games');
	
	//Navigation
	echo "<div class = 'nav'>
		<a href = '{$_SERVER['PHP_SELF']}'>Add a Game</a>
		<a href = 'logout.php'>Logout</a>
	</div>";
	
	
	
	//Display a list of games this user can administrate
	$query = "SELECT * FROM games JOIN game_editors ON (games.game_id = game_editors.game_id) 
		WHERE game_editors.editor_id = {$_SESSION['user_id']}";
	$result = mysql_query($query);
	
	echo '<table class = "games">
			<tr><th>Game Name</th><th>Database Prefix</th></tr>';
	
	while ($row=mysql_fetch_array($result)) 
		echo "<tr><td><a href = 'games.php?game_id={$row['game_id']}'>{$row['name']}</a></td><td>{$row['prefix']}</td></tr>";
	
	
	echo '</table>';
?>