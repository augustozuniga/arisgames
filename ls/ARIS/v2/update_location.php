<?php

session_start();

if (isset($_REQUEST['latitude']) 
	&& isset($_REQUEST['longitude']) 
	&& isset($_SESSION['player_id'])
	&& isset($_GET['site'])) 
{	
	// Update Session
	$_SESSION['latitude']=$_REQUEST['latitude'];
	$_SESSION['longitude']=$_REQUEST['longitude'];
	$_SESSION['last_location_timestamp']=time();
	$_GET['site'] = $_GET['site'] . '_';
	
	/*************************************************************
	 Begin AWESOME GHETTO code now
	 ****************************************/
	
	$db = 'aris';
	$user = 'arisuser';
	$pass = 'arispwd';
	$host = 'localhost';
	
	//Update Player latatide and longitude in players table
	$query = "UPDATE players 
	SET latitude = '{$_REQUEST['latitude']}', longitude = '{$_REQUEST['longitude']}' 
	WHERE player_id = '{$_SESSION['player_id']}'";
	mysql_query($query);
	
	//Check for a matching location and add event if specified
	$gps_error_factor = .0001 ;

	$query = "SELECT * FROM {$_GET['site']}locations 
		WHERE 
		latitude < " .  ($_REQUEST['latitude'] + $gps_error_factor) . " AND latitude > " .  ($_REQUEST['latitude'] - $gps_error_factor) . 
		" AND longitude < " . ($_REQUEST['longitude'] + $gps_error_factor) . " AND longitude > " .  ($_REQUEST['longitude'] - $gps_error_factor);  

	$result = mysql_query($query);

	if ($location = mysql_fetch_array($result)) {
		//The player is at a known location
		
		//Update player record in db
		$query = "UPDATE players 
			SET last_location_id = '{$location['location_id']}' 
			WHERE player_id = '{$_SESSION['player_id']}'";
		mysql_query($query);
		
		//Update the session
		$_SESSION['location_id'] = $location['location_id'];
		$_SESSION['location_name'] = $location['name'];

		//Give event to player if specified in location record
		if (isset($location['add_event_id'])) {
			$query = "INSERT INTO {$_GET['site']}player_events (player_id, event_id)
			VALUES ('{$_SESSION['player_id']}','{$location['add_event_id']}')"; 		
			mysql_query($query);
		}
	
	}
	else {
		//The player has left a known location
		//Update player record in db
		$query = "UPDATE players 
			SET last_location_id = '' 
			WHERE player_id = '{$_SESSION['player_id']}'";
		mysql_query($query);
		
		//Update the session
		unset($_SESSION['location_id']);
		unset($_SESSION['location_name']);

		//Give event to player if specified in location record
		if (isset($location['add_event_id'])) {
			$query = "INSERT INTO {$_GET['site']}player_events (player_id, event_id)
			VALUES ('{$_SESSION['player_id']}','{$location['add_event_id']}')"; 		
			mysql_query($query);
		}
	}
}
else {
	echo 'Seriously? I need more vars than that.';
	
}

?>