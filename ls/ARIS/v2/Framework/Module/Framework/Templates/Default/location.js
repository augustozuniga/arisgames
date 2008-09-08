var number = 1;

function dirname(path) {
    return path.match( /.*\// )[0];
}

function update_location(lat, long) {
	var request = new XMLHttpRequest();
	var base = dirname(location.href);
	
	request.open('GET', base + 'update_location.php?latitude=' + 	
		lat + '&longitude=' + long, true);        		
	request.setRequestHeader('Content-Type', 'application/x-javascript;');        	
	request.onreadystatechange = function() {
			if (request.readyState == 4 && request.status == 200) {
				update_map(lat, long);
			}
		}
	request.send();
}

function update_map(lat, long) {
	img = document.getElementById('mapImg');
	if (img && map_cache) {
		img.src = map_cache + lat + ',' + long + ',yellow';
	}
}