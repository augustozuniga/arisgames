<?php
	
	include_once('common.inc.php');
	
	$query = "SELECT * FROM {$_SESSION['current_game_prefix']}locations";
	$result = mysql_query($query);
	$map_points = '';

	while ($row = mysql_fetch_array($result)){
		   $map_points .= "
			var point = new GLatLng({$row['latitude']}, {$row['longitude']});
			bounds.extend(point);
			var customIcon = new GIcon(baseIcon);
			//customIcon.image = \"{$engine_www_root}/{$row['media']}\";
			var marker_{$row['location_id']} = new GMarker(point,  { icon:customIcon, draggable:true });
			
			GEvent.addListener(marker_{$row['location_id']}, 'click', function(){ 
				marker_{$row['location_id']}.openExtInfoWindow(map,
									'custom_info_window_red',
									'<div>Loading...</div>',
									{
									ajaxUrl: 'locations_infowindow/infoWindow.php?location_id={$row['location_id']}', 
									beakOffset: 3
									}
									); 
			});
			GEvent.addListener(marker_{$row['location_id']}, 'dragstart', function() {
				map.closeInfoWindow();
			});
			
			GEvent.addListener(marker_{$row['location_id']}, 'dragend', function() {
				//Send update to handler script
				var update_url = 'locations_infowindow/update.php?req=update_location&location_id={$row['location_id']}&latitude=' + 
								marker_{$row['location_id']}.getLatLng().lat() + 
								'&longitude=' + marker_{$row['location_id']}.getLatLng().lng();
				GDownloadUrl(update_url, function(data){});
			});
			
			map.addOverlay(marker_{$row['location_id']});";
	}


				
	//Begin HTML
	echo '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
	<html xmlns="http://www.w3.org/1999/xhtml" xmlns:v="urn:schemas-microsoft-com:vml">
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title>Locations</title>
	<style type="text/css"> @import url("theme.css"); </style> 
	
	<link type="text/css" rel="Stylesheet" media="screen" href="locations_infowindow/infoWindow.css"/>
	
	<script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=' . $google_key . '"
	type="text/javascript"></script>
	<script src="js/extinfowindow.js" type="text/javascript"></script>
    <script type="text/javascript">
   	
	function initialize() {
		if (GBrowserIsCompatible()) {
			// Create a base icon for all of our markers that specifies the
			// shadow, icon dimensions, etc.
			var baseIcon = new GIcon(G_DEFAULT_ICON);
			baseIcon.shadow = "http://www.google.com/mapfiles/shadow50.png";
			baseIcon.iconSize = new GSize(20, 34);
			baseIcon.shadowSize = new GSize(37, 34);
			baseIcon.iconAnchor = new GPoint(9, 34);
			baseIcon.infoWindowAnchor = new GPoint(9, 2);
			
			//Bounds will be used to calculate the center and zoom
			var bounds = new GLatLngBounds();
	
			//Define the map and basic qualities
			var map = new GMap2(document.getElementById("map_canvas"));
			map.setCenter(new GLatLng(0, 0), 0); 
			map.addControl(new GSmallMapControl());
			map.addControl(new GMapTypeControl());' . 
			$map_points . '
			
			//Use the GLatLngBounds object that contains all the points to center and zoom
			map.setZoom(map.getBoundsZoomLevel(bounds)-1);
			map.setCenter(bounds.getCenter());
		}
    }
	
    </script>
	</head>
	
	<body onload="initialize()" onunload="GUnload()">';
	
	
	
	echo '<h1>Locations</h1>';
	print_general_navigation();
			
	
	echo '<div id="map_canvas" style="width: 100%; height: 300px"></div>';
	
	
	/**********************
	 PHP My Edit Config
	 *********************/
	
	// Select the Table Name
	$opts['tb'] = $_SESSION['current_game_prefix'] . 'locations';
		
	// Name of field which is the unique key
	$opts['key'] = 'location_id';
	
	// Type of key field (int/real/string/date etc.)
	$opts['key_type'] = 'int';
	
	// Sorting field(s)
	$opts['sort_field'] = array($opts['key']);
	
	// Number of records to display on the screen
	// Value of -1 lists all records in a table
	$opts['inc'] = 15;
	
	// Options you wish to give the users
	// A - add,  C - change, P - copy, V - view, D - delete,
	// F - filter, I - initial sort suppressed
	$opts['options'] = 'ACPVDF';
	
	// Number of lines to display on multiple selection filters
	$opts['multiple'] = '4';
	
	// Navigation style: B - buttons (default), T - text links, G - graphic links
	// Buttons position: U - up, D - down (default)
	$opts['navigation'] = 'GU';
	
	// Display special page elements
	$opts['display'] = array(
							 'form'  => true,
							 'query' => true,
							 'sort'  => false,
							 'time'  => false,
							 'tabs'  => true
							 );
	
	// Set default prefixes for variables
	$opts['js']['prefix']               = 'PME_js_';
	$opts['dhtml']['prefix']            = 'PME_dhtml_';
	$opts['cgi']['prefix']['operation'] = 'PME_op_';
	$opts['cgi']['prefix']['sys']       = 'PME_sys_';
	$opts['cgi']['prefix']['data']      = 'PME_data_';
	
	/* Get the user's default language and use it if possible or you can
	 specify particular one you want to use. Refer to official documentation
	 for list of available languages. */
	$opts['language'] = $_SERVER['HTTP_ACCEPT_LANGUAGE'] . '-UTF8';
	
	/* Table-level filter capability. If set, it is included in the WHERE clause
	 of any generated SELECT statement in SQL query. This gives you ability to
	 work only with subset of data from table.
	 
	 $opts['filters'] = "column1 like '%11%' AND column2<17";
	 $opts['filters'] = "section_id = 9";
	 $opts['filters'] = "PMEtable0.sessions_count > 200";
	 */
	
	/* Field definitions
	 
	 Fields will be displayed left to right on the screen in the order in which they
	 appear in generated list. Here are some most used field options documented.
	 
	 ['name'] is the title used for column headings, etc.;
	 ['maxlen'] maximum length to display add/edit/search input boxes
	 ['trimlen'] maximum length of string content to display in row listing
	 ['width'] is an optional display width specification for the column
	 e.g.  ['width'] = '100px';
	 ['mask'] a string that is used by sprintf() to format field output
	 ['sort'] true or false; means the users may sort the display on this column
	 ['strip_tags'] true or false; whether to strip tags from content
	 ['nowrap'] true or false; whether this field should get a NOWRAP
	 ['select'] T - text, N - numeric, D - drop-down, M - multiple selection
	 ['options'] optional parameter to control whether a field is displayed
	 L - list, F - filter, A - add, C - change, P - copy, D - delete, V - view
	 Another flags are:
	 R - indicates that a field is read only
	 W - indicates that a field is a password field
	 H - indicates that a field is to be hidden and marked as hidden
	 ['URL'] is used to make a field 'clickable' in the display
	 e.g.: 'mailto:$value', 'http://$value' or '$page?stuff';
	 ['URLtarget']  HTML target link specification (for example: _blank)
	 ['textarea']['rows'] and/or ['textarea']['cols']
	 specifies a textarea is to be used to give multi-line input
	 e.g. ['textarea']['rows'] = 5; ['textarea']['cols'] = 10
	 ['values'] restricts user input to the specified constants,
	 e.g. ['values'] = array('A','B','C') or ['values'] = range(1,99)
	 ['values']['table'] and ['values']['column'] restricts user input
	 to the values found in the specified column of another table
	 ['values']['description'] = 'desc_column'
	 The optional ['values']['description'] field allows the value(s) displayed
	 to the user to be different to those in the ['values']['column'] field.
	 This is useful for giving more meaning to column values. Multiple
	 descriptions fields are also possible. Check documentation for this.
	 */

	
	$opts['fdd']['location_id'] = array(
										'name'     => 'Location ID',
										'select'   => 'T',
										'options'  => 'AVCPDLF', // auto increment
										'maxlen'   => 11,
										'default'  => '0',
										'sort'     => true
	);
	$opts['fdd']['name'] = array(
								 'name'     => 'Name',
								 'select'   => 'T',
								 'maxlen'   => 50,
								 'sort'     => true
	);
	$opts['fdd']['description'] = array(
										'name'     => 'Description',
										'select'   => 'T',
										'maxlen'   => 255,
										'textarea' => array(
															'rows' => 5,
															'cols' => 50),
										'sort'     => true,
										'options'	=> 'AVCPD'
	);
	$opts['fdd']['media'] = array(
								  'name'     => 'Media',
								  'select'   => 'T',
								  'maxlen'   => 30,
								  'sort'     => true
	);
	$opts['fdd']['latitude'] = array(
										 'name'     => 'Latitude',
										 'select'   => 'T',
										 'maxlen'   => 10,
										 'sort'     => true,
										 'options'	=> 'AVCPD'
										 );
	$opts['fdd']['longitude'] = array(
											 'name'     => 'Longitude',
											 'select'   => 'T',
											 'maxlen'   => 10,
											 'sort'     => true,
											 'options'	=> 'AVCPD'		
									  );
	$opts['fdd']['type'] = array(
								 'name'     => 'What is at this location?',
								 'select'   => 'T',
								 'maxlen'   => 5,
								 'values'   => array(
													 "Node",
													 "Event",
													 "Item",
													 "Npc"),
								 'sort'     => true
	);
	$opts['fdd']['type_id'] = array(
									'name'     => 'What is that thing\'s ID?',
									'select'   => 'T',
									'maxlen'   => 11,
									'sort'     => true
	);
	$opts['fdd']['add_event_id'] = array(
										 'name'     => 'Add event ID',
										 'select'   => 'T',
										 'maxlen'   => 10,
										 'sort'     => true,
										 'options'	=> 'AVCPD'
										 );
	$opts['fdd']['require_event_id'] = array(
											 'name'     => 'Require event ID',
											 'select'   => 'T',
											 'maxlen'   => 10,
											 'sort'     => true,
											 'options'	=> 'AVCPD'									
											 );
	$opts['fdd']['remove_if_event_id'] = array(
											   'name'     => 'Remove if event ID',
											   'select'   => 'T',
											   'maxlen'   => 10,
											   'sort'     => true,
											   'options'	=> 'AVCPD'
											   );
	
	
	
	// Now important call to phpMyEdit
	echo "<p>NOTICE: After adding a new location, you must <a href = '{$_SERVER['PHP_SELF']}'>update the map</a></p>";
	require_once 'extensions/phpMyEdit-mce-cal.class.php';		
	//new phpMyEdit($opts);
	new phpMyEdit_mce_cal($opts);
	
	print_footer();
	?>
