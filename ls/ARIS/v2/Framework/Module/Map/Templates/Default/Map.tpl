<p><img id="mapImg" src="{$mapPath}" /></p>
<script type="text/javascript">var map_cache = "{$mapPathCache}";</script>
<ol class="locations">
	{foreach from=$allLocations item=location}
		{if $location.location_id == $player_location_id}
		<li>{link text=$location.name module=Map event=displayLocation}</li>
		{else}
		<li>{$location.name}</li>
		{/if}
	{/foreach}
</ol>