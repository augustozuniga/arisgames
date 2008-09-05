<table class="inventoryList">
	<caption>Current Assets</caption>
	<tbody>
{if count($inventory) > 0}
{foreach from=$inventory item=item}
	<tr>
		<td><img src="{$item.media}"></td>
		<td>
			<table>
				<tr><td>{$item.name}</td></tr>
				<tr><td>{$item.description}</td></tr>
			</table>
		</td>
	</tr>
{/foreach}
	</tbody>
{else}
	<tr><td></td><td>No Items</td></tr>
{/if}
</table>
