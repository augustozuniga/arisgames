<p>Set current location to:</p>
{if count($locations) > 0}
<ul class = 'developer'>
{foreach from=$locations item=location}
	<li><a href = 'javascript:update_location({$location.latitude},{$location.longitude});'>{$location.name}</a></li>
{/foreach}
</ul>
{else}
	<p>No Locations defined in this game.<p>
{/if}
