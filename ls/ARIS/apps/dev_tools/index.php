<?php

require_once('../../common.php');
unset($_SESSION['current_npc_id']);

page_header();

echo '<h1>Developer Tools</h1>';

echo "<p><a href='{$_SERVER['PHP_SELF']}?function=reset_events'>Reset my Events</a></p>";
echo "<p><a href='{$_SERVER['PHP_SELF']}?function=reset_items'>Reset my Items</a></p>";
echo "<p><a href='{$_SERVER['PHP_SELF']}?function=clear_session'>Clear the Session</a></p>";

if (isset($_REQUEST['function'])) {

	if ($_REQUEST['function'] == 'reset_events') { 
		$query = "DELETE {$GLOBALS['DB_TABLE_PREFIX']}player_events WHERE player_id = '{$_SESSION['player_id']}'";
		mysql_query($query);
	}
	
	if ($_REQUEST['function'] == 'reset_items') { 
		$query = "DELETE {$GLOBALS['DB_TABLE_PREFIX']}player_items WHERE player_id = '{$_SESSION['player_id']}'";
		mysql_query($query);
	}
	
	if ($_REQUEST['function'] == 'clear_session') { 
		$player_id = $_SESSION['player_id'];
		session_destroy();
		$_SESSION['player_id'] = $player_id;
	}

}

page_footer();