<table class="Inventory">
{foreach from=$inventory item=item}
	<tr>
		<td><img id="itemImg" src="{$item.media}" width = "50px"/></td>
		<td>{link text=$item.name module=Inventory event="displayItem&item_id=`$item.item_id`"}</td>
	</tr>	
{/foreach}
</table>