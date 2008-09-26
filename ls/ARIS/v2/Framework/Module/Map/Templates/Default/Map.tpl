<p class="mapContainer"><img id="mapImg" src="{$mapPath}" /></p>
<!--OPEN ED HACK<script type="text/javascript">var map_cache = "{$mapPathCache}";</script>-->
<ol class="locations">
	{foreach from=$allLocations item=location}
		{if $location.location_id == $player_location_id}
		<li>{link text=$location.name module=Map event="displayLocation&location_id=`$location.location_id`"}</li>
		{else}
		<li>{$location.name}</li>
		{/if}
	{/foreach}
</ol>