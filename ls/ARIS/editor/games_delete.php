<?php	
	
	include_once('common.inc.php');
	print_header('Delete an ARIS Game');
	
	//Navigation
	echo "<div class = 'nav'>
	<a href = 'index.php'>Back to Game Selection</a>
	<a href = 'logout.php'>Logout</a>
	</div>";
	
	if (isset($_REQUEST['prefix']) and isset($_REQUEST['confirmed'])) {
		//Go ahead and delete the data
		delete($_REQUEST['prefix'],$engine_sites_path);
		//echo $_REQUEST['prefix'];
		
	}

	else if (isset($_REQUEST['game_id'])){
		$query = "SELECT * FROM games WHERE game_id = {$_REQUEST['game_id']}";
		$result = mysql_query($query);
		$row = mysql_fetch_array($result);
		$prefix = substr($row['prefix'],0,strlen($row['prefix'])-1);

		echo "<h3>Are you sure you want to delete {$row['name']}?</h3><h3>This cannot be undone!</h3>";
		echo "<a href = 'index.php'>Cancel</a> / <a href = '{$_SERVER['PHP_SELF']}?prefix={$prefix}&confirmed=true'>Continue Delete</a>";
	}
	
	

	function delete($prefix,$path) {
		echo '<h3>Start Delete...</h3>';
		//Delete the game record
		$query = "DELETE FROM games WHERE prefix = '{$prefix}_'";
		mysql_query($query);
		echo '<p>' . $query . '</p>';
		echo mysql_error();
		
		//Delete the files
		echo "<p>rm -rf {$path}/{$prefix}</p>";
		echo exec("rm -rf {$path}/{$prefix}");
		
		echo "<p>rm {$path}/{$prefix}.php</p>";
		echo exec("rm {$path}/{$prefix}.php");
		
		//Delete each table with this prefix
		$query = "DROP TABLE {$prefix}_applications";
		mysql_query($query);
		echo '<p>' . $query . '</p>';
		echo mysql_error();
		
		$query = "DROP TABLE {$prefix}_events";
		mysql_query($query);
		echo '<p>' . $query . '</p>';
		echo mysql_error();
		
		$query = "DROP TABLE {$prefix}_items";
		mysql_query($query);
		echo '<p>' . $query . '</p>';
		echo mysql_error();
		
		$query = "DROP TABLE {$prefix}_locations";
		mysql_query($query);
		echo '<p>' . $query . '</p>';
		echo mysql_error();
		
		$query = "DROP TABLE {$prefix}_log";
		mysql_query($query);
		echo '<p>' . $query . '</p>';
		echo mysql_error();
		
		$query = "DROP TABLE {$prefix}_nodes";
		mysql_query($query);
		echo '<p>' . $query . '</p>';
		echo mysql_error();
		
		$query = "DROP TABLE {$prefix}_npc_conversations";
		mysql_query($query);
		echo '<p>' . $query . '</p>';
		echo mysql_error();
		
		$query = "DROP TABLE {$prefix}_npcs";
		mysql_query($query);
		echo '<p>' . $query . '</p>';
		echo mysql_error();
		
		$query = "DROP TABLE {$prefix}_player_applications";
		mysql_query($query);
		echo '<p>' . $query . '</p>';
		echo mysql_error();
		
		$query = "DROP TABLE {$prefix}_player_events";
		mysql_query($query);
		echo '<p>' . $query . '</p>';
		echo mysql_error();
		
		$query = "DROP TABLE {$prefix}_player_items";
		mysql_query($query);
		echo '<p>' . $query . '</p>';
		echo mysql_error();
		
		echo '<h3>Done! Review the messages above for errors.</h3>';
	}