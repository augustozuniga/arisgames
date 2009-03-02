{if count($locations) > 0}
<locations>
{foreach from=$locations item=location}
	<location id="{$location.location_id}" name="{$location.name}" latitude="{$location.latitude}" longitude="{$location.longitude}" />
{/foreach}
</locations>
{else}
<locations />
{/if}
