<div id="map_canvas" style="width: {$mapWidth}px; height: {$mapHeight}px"></div>

<ol class="locations">
	{foreach from=$allLocations item=location}
		<li>{$location.name}</li>
	{/foreach}
</ol>