<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Finding your Location with Loki</title>

<script type="text/javascript" src="http://loki.com/javascript/loki.js"></script>



<script type="text/javascript">

function find_me() {
  	
	//Try Loki
  	var loki = LokiAPI();
  	if (loki) {

		loki.onSuccess = function(location) {
		//document.write(location.latitude +' '+location.longitude);
		//window.location = "location.php?latitude="+location.latitude+"&longitude"+location.longitude;
		window.location="<?php echo $GLOBALS['WWW_ROOT']; ?>/apps/map/index.php?latitude=" + location.latitude + "&longitude=" + location.longitude;
		document.close();
	}
	
	loki.onFailure = function(error) {document.write(error)}
    loki.setKey('gls');
    loki.requestLocation(true,loki.NO_STREET_ADDRESS_LOOKUP);
	
  	}
  	else window.location="<?php echo $GLOBALS['WWW_ROOT']; ?>/apps/map/index.php"; 

}
</script>


</head>
<body onLoad="find_me();">

Getting location from Loki...

</body>
</html>
