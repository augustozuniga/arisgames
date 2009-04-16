<nearbyLocations>
{foreach from=$links item=object}
	{if $object.type == 'Item'}
		<item id="{$item.item_id}" name="{$item.name}" type="{$item.type}" description="{$item.description}" iconURL="{$item.icon}" mediaURL="{$item.mediaURL}" />
	{else}
		<nearbyLocation type="{$object.type}" id="{$object.id}" label="{$object.label}" iconURL="{$object.icon}" URL = "{$object.url}"/>
	{/if}
{/foreach}
</nearbyLocations>