<?php

include_once('../common.inc.php');
	//insert a new node
	$query = "INSERT INTO {$_SESSION['current_game_prefix']}items (name) VALUES ('*NEW ITEM* at {$_REQUEST['location_name']}')";
	mysql_query($query);
	
	//get its id
	$new_id = mysql_insert_id();
		
	//modify the location to point to this node
	$query = "UPDATE {$_SESSION['current_game_prefix']}locations SET type = 'item', type_id = '$new_id'";
	mysql_query($query);

	//open the node using its id
	echo "<script type='text/javascript'>
		window.location='../items.php?PME_sys_fl=0&PME_sys_fm=15&PME_sys_sfn[0]=0&PME_sys_operation=PME_op_Change&PME_sys_rec={$new_id}';
		</script>";
	
	
?>