<?php
include ('common.php');

if (isset($_REQUEST['latitude']) and isset($_REQUEST['longitude'])) {
	$query = "UPDATE {$GLOBALS['DB_TABLE_PREFIX']}players 
			SET latitude = '{$_REQUEST['latitude']}', longitude = '{$_REQUEST['longitude']}' 
			WHERE player_id = '{$_SESSION['player_id']}'";
	mysql_query($query);
}

/*
//we are on the GPS and have an update, refresh the screen
if ($_SERVER['PHP_SELF'] == "{$GLOBALS['WWW_ROOT']}/apps/map/index.php") {
	echo "<script type='text/javascript'>
				window.parent.location = '{$GLOBALS['WWW_ROOT']}/apps/map/index.php';
			</script>";

}
*/
?>

