<table class="contactList">
{foreach from=$npcs item=npc}
	<tr>
		<td>
			{if $npc.media}
				{link module="NodeViewer" event="conversation&npc_id=`$npc.npc_id`" text="<img src='Framework/Site/$site/Templates/Default/templates/`$npc.media`' />"}
			{/if}
		</td>
		<td>
			<h2>{link module="NodeViewer" event="conversation&npc_id=`$npc.npc_id`" text=$npc.name}</h2>
			<p>{$npc.description}</p>
		</td>	
	</tr>
{/foreach}
</table>