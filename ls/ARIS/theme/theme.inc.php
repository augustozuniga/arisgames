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
	
	echo '
		</style>
		</head>
		<body>	
		<div id="container">
		<div id="content">
	';

} //end function





/*
Close all tags and display footer
*/
function page_footer() {
	$moduleRoot = "{$GLOBALS['WWW_ROOT']}/apps";
	
	
	echo <<<MODULES
	</div><!--Close content div-->
	<table id="nav">
		<tr>
			<td>
				<a href="{$moduleRoot}/log/index.php"><img src="$moduleRoot/log/icon.png" /></a>
			</td>
			<td>
				<a href="{$moduleRoot}/im/index.php"><img src="$moduleRoot/im/icon.png" /></a>
			</td>
			<td>
				<a href="{$moduleRoot}/../get_location_combined.php"><img src="$moduleRoot/map/icon.png" /></a>
			</td>
			<td>
				<a href="{$moduleRoot}/inventory/index.php"><img src="$moduleRoot/inventory/icon.png" /></a>
			</td>
		</tr>
	</table>
	
MODULES;
	
/*	
	<a href = '$GLOBALS[WWW_ROOT]/apps/im/index.php'><img src = '$GLOBALS[WWW_ROOT]/apps/im/icon.png' /></a>
	<a href = '$GLOBALS[WWW_ROOT]/get_location_combined.php'><img src = '$GLOBALS[WWW_ROOT]/apps/map/icon.png' /></a>
	<a href = '$GLOBALS[WWW_ROOT]/apps/inventory/index.php'><img src = '$GLOBALS[WWW_ROOT]/apps/inventory/icon.png' /></a>
	";
/*
	<a href = '$GLOBALS[WWW_ROOT]/apps/scan/index.php'><img src = '$GLOBALS[WWW_ROOT]/apps/scan/icon.png' width = '50px'/></a>
	<a href = '$GLOBALS[WWW_ROOT]/apps/rotunda_puzzle/index.php'><img src = '$GLOBALS[WWW_ROOT]/apps/rotunda_puzzle/icon.png' width = '50px'/></a>
	<a href = '$GLOBALS[WWW_ROOT]/logout.php'><img src = '$GLOBALS[WWW_ROOT]/theme/logout_icon.png' width = '50px'/></a>
	<a href = '$GLOBALS[WWW_ROOT]/apps/dev_tools/index.php'><img src = '$GLOBALS[WWW_ROOT]/apps/dev_tools/icon.png' width = '50px'/></a>
	";
*/			
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