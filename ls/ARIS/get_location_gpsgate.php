<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Finding your Location</title>



<script type="text/javascript" src="http://localhost:12175/javascript/GpsGate.js"></script>
<script type="text/javascript">
  //<![CDATA[

  // That is the callback function that is specified in getGpsInfo() and 
  // executed after the data is returned
  // See more info on the returned "gps" object below.

        if (typeof(GpsGate) == 'undefined' || typeof(GpsGate.Client) == 'undefined')
        {
                alert('GpsGate not installed or not started!');
        }

        function gpsGateCallback(gps){
		window.location="<?php echo $GLOBALS['WWW_ROOT']; ?>/apps/map/index.php?latitude=" + gps.trackPoint.position.latitude + "&longitude=" + gps.trackPoint.position.longitude;
		
				document.close();
        }

  //]]>
</script>



</head>


  	


<body onLoad="GpsGate.Client.getGpsInfo(gpsGateCallback);">




</body>
</html>
