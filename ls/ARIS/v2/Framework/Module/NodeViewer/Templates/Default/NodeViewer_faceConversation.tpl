<ul class="options">
{foreach from=$conversations item=msg}
	<li>{link text=$msg.text module="NodeViewer" event="faceTalk&node_id=`$msg.node_id`&npc_id=`$npc.npc_id`"}</li>
{/foreach}
</ul>