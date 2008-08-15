<?php

/*
Output standard html tags and load the common css. If a param is passed, attional css can be loaded as well
*/

function page_header($additional_layout=null) {

	echo '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<meta name="viewport" content="width=device-width">
		<title>'. $GLOBALS['TITLE'] . '</title>
		<style type="text/css" media="all">
		@import url('. $GLOBALS['WWW_ROOT'] . '/theme/common.css);
	';
	
	
	if ($additional_layout != null) echo "@import url($additional_layout);";
	
	echo "
		</style>
		
		<script type='text/javascript'>
		var number = 1;

		function update_location(lat, long) {
 			frames['utils_frame'].location.href = '{$GLOBALS['WWW_ROOT']}/update_location.php?latitude=' + lat + '&longitude=' + long;
        	number++;
		}
	
		</script>
		</head>
		<body>	
		<iframe src='{$GLOBALS['WWW_ROOT']}/update_location.php' id='utils_frame' name='utils_frame'style='width:0px; height:0px; border: 0px'></iframe>
		<div id='container'>
		<div id='content'>";

} //end function





/*
Close all tags and display footer
*/
function page_footer() {
	$moduleRoot = "{$GLOBALS['WWW_ROOT']}/apps";
	
	
	echo '</div><!--Close content div-->
	<table id="nav">
			<tr>';
	
	//Query the applications table to determin which should be displayed
	$query = "SELECT * FROM {$GLOBALS['DB_TABLE_PREFIX']}applications 
		JOIN {$GLOBALS['DB_TABLE_PREFIX']}player_applications 
		ON {$GLOBALS['DB_TABLE_PREFIX']}applications.application_id = {$GLOBALS['DB_TABLE_PREFIX']}player_applications.application_id 
		WHERE {$GLOBALS['DB_TABLE_PREFIX']}player_applications.player_id = '$_SESSION[player_id]'";
				
	$result = mysql_query($query);	
	echo mysql_error();
	while ($app = mysql_fetch_array($result)) {
		echo "<td><a href='{$moduleRoot}/{$app['directory']}/index.php'><img src='{$moduleRoot}/{$app['directory']}/icon.png'/></a></td>";
	}
			
	echo "
	<td>
		<a href = '$GLOBALS[WWW_ROOT]/logout.php'><img src = '$GLOBALS[WWW_ROOT]/theme/logout_icon.png' width = '50px'/></a>
	</td>
	</tr>
		</table>";
	
	echo '
		<script type="text/javascript">
 		 //<![CDATA[
	';
	
	if (!defined('IM')) {
			echo 'window.onload = function() {setTimeout(function(){window.scrollTo(0, 1);}, 100);}';

	}
	echo '
         //]]>
		</script>
	</div><!--Close nav div-->
	</div><!--Close container div-->
	</body>
	</html>';
}


/*
Close all tags and display footer without navigation
*/
function page_footer_no_nav() {
	echo '
		</div><!--Close content div-->
		</div><!--Close container div-->
		</body>
		</html>
	';
}

?>