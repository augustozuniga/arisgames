<?php

require_once('common.php');

function print_form() {
	echo "<form action = '$_SERVER[PHP_SELF]' method = 'post'>
	
	<table cellspacing='10'>
		<tr>
			<td>Username</td>
			<td><input type = 'text' size = '10' name = 'user_name'></td>
		</tr>
		<tr>
			<td>Password</td>
			<td><input type = 'password' size = '10' name = 'password'></td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td>
				&nbsp;
			</td>
			<td><input type = 'hidden' name = 'req' value = 'login'><input type = 'hidden' name = 'location_detection' value = 'none'><input type = 'submit' value = 'login'></td
		</tr>
	</table>";
	page_footer_no_nav();
}


if (!isset($_REQUEST['req'])) {
	page_header();
	echo '<h1>Login to the GLS Tour of Madison</h1>
			<p>This site is best viewed on iPhone</p>
			<p>Please pick up your login from the information desk at the conference</p>';
	print_form();
}
else {
	$query = "SELECT * FROM {$GLOBALS['DB_TABLE_PREFIX']}players WHERE user_name = '$_REQUEST[user_name]' and password = '$_REQUEST[password]'";
	$result = mysql_query($query);
	$row = mysql_fetch_array($result);
	if ($row) {


		$_SESSION['location_detection'] = $_REQUEST['location_detection'];
		//Login successfull, load data
		$_SESSION['player_id'] = $row['player_id'];
		$_SESSION['user_name'] = $row['user_name'];
		$_SESSION['first_name'] = $row['first_name'];
		$_SESSION['last_name'] = $row['last_name'];
		$_SESSION['player_photo'] = $row['photo'];
		
		page_header();
		echo "<h1>Welcome back $_SESSION[first_name].</h2>";
		echo "<p>Applications initialized</p>";
		page_footer();
	}
	else {
		//No matching Username and password
		page_header();
		echo "<h1>Login</h2>";
		echo "<p>Access Denied.</p>";
		print_form();
		page_footer_no_nav();
	}
}
		
		
	
?>