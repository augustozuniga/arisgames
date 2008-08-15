<?php
require_once('../../common.php');

if (isset($_SESSION['profile_page'])) { 
	switch ($_SESSION['profile_page']) {
		case 1:
			include ('profile1.php');
			break;
		case 2:
			include ('profile2.php');
			break;
		case 3:
			include ('profile3.php');
			break;
		case 4:
			include ('profile4.php');
			break;
		case 5:
			include ('profile5.php');
			break;	
	}
}
else include ('intro.php');

?>
</p>
