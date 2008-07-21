<?php
require_once('../../common.php');
unset($_SESSION['current_npc_id']);

page_header();

if (!isset($_REQUEST['item_id'])) {
	echo '<h1>Current Inventory</h1>';
	
	$query = "SELECT * FROM {$GLOBALS['DB_TABLE_PREFIX']}items JOIN {$GLOBALS['DB_TABLE_PREFIX']}player_items ON {$GLOBALS['DB_TABLE_PREFIX']}items.item_id = {$GLOBALS['DB_TABLE_PREFIX']}player_items.item_id WHERE {$GLOBALS['DB_TABLE_PREFIX']}player_items.player_id = '$_SESSION[player_id]'";
				
	$result = mysql_query($query);
	
	echo '<table cellspacing = "5px">';
	
	if (mysql_num_rows($result) == 0) echo "<tr><td>Inventory is Empty</td></tr>";
	
	while ($row = mysql_fetch_array($result)) {
		echo '<tr>';
		echo "<td><a href = '$_SERVER[PHP_SELF]?item_id=$row[item_id]'><img width = '75px' height = '100px' src='$WWW_ROOT/media/$row[media]'/></a></td>
		<td><h2><a href = '$_SERVER[PHP_SELF]?item_id=$row[item_id]'>$row[name]</a></h2><p>$row[description]</p></td>";
		echo '</tr>';
	}
	
	echo '</table>';

}

else {
	//We are comming back to display an item full screen
	$query = "SELECT * FROM {$GLOBALS['DB_TABLE_PREFIX']}items WHERE item_id = '$_REQUEST[item_id]'";		
	$result = mysql_query($query);
	$row = mysql_fetch_array($result);
	echo "<h1>$row[name]</h1>";
	echo "<p align = 'center'><img src = '{$WWW_ROOT}/media/{$row['media']}'/></p>";
	echo "<p align = 'center'>$row[description]</p>";
	echo "<p align = 'center'><a href = $_SERVER[PHP_SELF]/>Back to Inventory List </a></p>";
	
}

page_footer();


?>

