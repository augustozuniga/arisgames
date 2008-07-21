<?php

include ('common.php');

if (isSet($_SESSION['location_detection']) and $_SESSION['location_detection'] == 'loki') include ('get_location_loki.php');
else if (isSet($_SESSION['location_detection']) and $_SESSION['location_detection'] == 'gpsgate') include ('get_location_gpsgate.php');
else include ('get_location_none.php');



?>