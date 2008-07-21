<?php

require_once('../../common.php');

page_header();


echo '<h1>Activity Log</h1>';


//Display the current tasks

echo "<hr/>";

echo '<h2>Current Tasks</h2>';

$query = "SELECT * FROM {$GLOBALS['DB_TABLE_PREFIX']}log
			LEFT OUTER JOIN {$GLOBALS['DB_TABLE_PREFIX']}player_events ON {$GLOBALS['DB_TABLE_PREFIX']}log.require_event_id = {$GLOBALS['DB_TABLE_PREFIX']}player_events.event_id
			WHERE 
			(require_event_id IS NULL OR player_id = $_SESSION[player_id]) 
			and 
			({$GLOBALS['DB_TABLE_PREFIX']}log.complete_if_event_id IS NULL OR {$GLOBALS['DB_TABLE_PREFIX']}log.complete_if_event_id NOT IN (SELECT event_id FROM {$GLOBALS['DB_TABLE_PREFIX']}player_events WHERE player_id = $_SESSION[player_id]))";
$result = mysql_query($query);

echo '<table>';
while ($row = mysql_fetch_array($result)) {
	echo '<tr>';
	echo "<td><img class = 'quest_list' src='$WWW_ROOT/media/$row[media]'</td>
	<td><h2><!--<a class = 'quest_list' href = '$WWW_ROOT/node.php?node=$row[start_node_id]'>-->$row[name]</a></h2><p>$row[description]</p></td>";
	echo '</tr>';
}
echo '</table>';





//Display the completed tasks

echo "<hr/>";

echo '<h2>Completed Tasks</h2>';

$query = "SELECT * FROM {$GLOBALS['DB_TABLE_PREFIX']}log
			WHERE {$GLOBALS['DB_TABLE_PREFIX']}log.complete_if_event_id IN (SELECT event_id FROM {$GLOBALS['DB_TABLE_PREFIX']}player_events WHERE player_id = $_SESSION[player_id])";
			
$result = mysql_query($query);

echo '<table>';

while ($row = mysql_fetch_array($result)) {
	echo '<tr>';
	echo "<td><img class = 'quest_list' src='$WWW_ROOT/media/$row[media]'</td>
		<td><h2>$row[name]</h2><p>$row[text_when_complete]</p></td>";
	echo '</tr>';
}

echo '</table>';


page_footer();

?>