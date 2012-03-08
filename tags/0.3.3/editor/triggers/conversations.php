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
	
	//if remove_if_event_id
	if ($newvals["remove_if_event_id"] == 'ADD') {	
		//insert a new item
		$new_id = new_event("New event to remove conversation " . $this->rec);
		
		//store new id here, replacing 'add'
		$query = "UPDATE $this->tb SET remove_if_event_id = '{$new_id}' WHERE conversation_id = '{$this->rec}'";
		mysql_query($query); //for add
		$newvals["remove_if_event_id"] = $new_id; //for update
	}			
	
	
	//If require_item_id field is set to 'add'
	if ($newvals["require_item_id"] == 'ADD') {	
		
		//insert a new item
		$new_id = new_item("New Item required by node " . $this->rec);
		
		//store new id here, replacing 'add'
		$query = "UPDATE $this->tb SET require_item_id = '{$new_id}' WHERE conversation_id = '{$this->rec}'";
		mysql_query($query); //for add
		$newvals["require_item_id"] = $new_id; //for update
	}
	
	
	
	//If require_event_id
	if ($newvals["require_event_id"] == 'ADD') {	
		//insert a new item
		$new_id = new_event("New required event by conversation " . $this->rec);
		
		//store new id here, replacing 'add'
		$query = "UPDATE $this->tb SET require_event_id = '{$new_id}' WHERE conversation_id = '{$this->rec}'";
		mysql_query($query); //for add
		$newvals["require_event_id"] = $new_id; //for update
	}			
	
	
	//if node_id
	if ($newvals["node_id"] == 'ADD') {	
		
		//insert a new item
		$new_id = new_node("New node from conversation " . $this->rec);
		
		//store new id here, replacing 'add'
		$query = "UPDATE $this->tb SET node_id = '{$new_id}' WHERE conversation_id = '{$this->rec}'";
		mysql_query($query); //for add
		$newvals["node_id"] = $new_id; //for update
	}		
	
	
	//if npc_id
	if ($newvals["npc_id"] == 'ADD') {	
		
		//insert a new item
		$new_id = new_npc("New NPC for conversation " . $this->rec);
		
		//store new id here, replacing 'add'
		$query = "UPDATE $this->tb SET npc_id = '{$new_id}' WHERE conversation_id = '{$this->rec}'";
		mysql_query($query); //for add
		$newvals["npc_id"] = $new_id; //for update
	}		
	
	
	function new_node($text) {
		//Insert a new node
		$table = $_SESSION['current_game_prefix'].'nodes';
		$query = "INSERT INTO $table (text) VALUES ('{$text}')";
		mysql_query($query);
		return mysql_insert_id();	
	}
	
	function new_item($name) {
		//Insert a new item
		$table = $_SESSION['current_game_prefix'].'items';
		$query = "INSERT INTO $table (name) VALUES ('{$name}')";
		mysql_query($query);
		return mysql_insert_id();	
	}		
	
	function new_event($desc) {
		//Insert a new event
		$table = $_SESSION['current_game_prefix'].'events';
		$query = "INSERT INTO $table (description) VALUES ('{$desc}')";
		mysql_query($query);
		return mysql_insert_id();	
	}
	
	function new_npc($name) {
		//Insert a new npc
		$table = $_SESSION['current_game_prefix'].'npcs';
		$query = "INSERT INTO $table (name) VALUES ('{$name}')";
		mysql_query($query);
		return mysql_insert_id();	
	}
	
	
	?>