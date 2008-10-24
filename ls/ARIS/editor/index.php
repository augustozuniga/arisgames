<?php	

	include_once('common.inc.php');

	//Clear Session variable for current game
	unset($_SESSION['current_game_prefix']);
	
	print_header('Your ARIS Games');
	
	echo '<!--Editor revision: ';
	include ('version');
	echo '-->';
	
	//Navigation
	echo "<div class = 'nav'>
		<a href = 'games_add.php'>Add a Game</a>
		<a href = ''>Upload a Game</a>
		<a href = 'logout.php'>Logout</a>
	</div>";
	
	
	
	//Display a list of games this user can administrate
	$query = "SELECT * FROM games JOIN game_editors ON (games.game_id = game_editors.game_id) 
		WHERE game_editors.editor_id = {$_SESSION['user_id']}";
	$result = mysql_query($query);
	
	echo '<table class = "games">
			<tr><th>Game Name</th><th>Prefix</th></tr>';
	
	while ($row=mysql_fetch_array($result)) 
		echo "<tr>
				<td><a href = 'games.php?game_id={$row['game_id']}'>{$row['name']}</a></td><td>{$row['prefix']}</td>
				<td><a href = 'games_delete.php?game_id={$row['game_id']}'>Delete</a></td>
				<td><a href = ''>Download</a></td>
				<td><a href = ''>Copy</a></td>
			</tr>";
	
	
	echo '</table>';
	
	
?>