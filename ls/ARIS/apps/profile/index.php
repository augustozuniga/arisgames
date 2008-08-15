<?php
require_once('../../common.php');

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
	default:
		include ('intro.php');
		
}

?>
</p>
