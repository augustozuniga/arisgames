<?php
	/*
	 Variables available within a trigger include:
	 $this - object reference
	 $this->dbh - nitialized MySQL database handle
	 $this->key - primary key name
	 $this->key_type - primary key type
	 $this->key_delim - primary key deliminator
	 $this->rec - primary key value (update and delete only)
	 $newvals  - associative array of new values (update and insert only)
	 $oldvals - associative array of old values (update and delete only)
	 $changed - array of keys with changed values
	 */
	
	//var_dump ($newvals);
	
	echo $newvals['opt1_text'];
	
	//If any of the optX_node_id fields are set to 'add'
	for ($i = 1; $i <= 3; $i++){
		if ($newvals["opt{$i}_node_id"] == 'ADD') {	
	
			//insert a new node
			$new_id = new_node($this->tb, "New Node from " . $this->rec .  " - " . $newvals["opt{$i}_text"]);
	
			//store new id here, replacing 'add'
			$newvals["opt{$i}_node_id"] = $new_id;
	
			//launch form for new node in a new window
			//echo "<script type='text/javascript'>
			//window.location='./nodes.php?PME_sys-rec={$new_id}&PME_sys_operation=PME_op_Change';
			//</script>";
			
		}
	}
	
	function new_node($table,$text) {
		//Insert a new node
		$query = "INSERT INTO $table (text) VALUES ('{$text}')";
		mysql_query($query);
		return mysql_insert_id();	
	}
?>