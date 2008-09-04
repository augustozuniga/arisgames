<div class="npcText">
{if isset($npc.media)}
	<div class="npcImg">
		<img src="Framework/Site/{$site}/Templates/Default/templates/{$npc.media}" />
	</div>
{/if}
{$node.text}
</div>
<ul class="options">
{foreach from=$conversations item=msg}
	<li>{link text=$msg.text module="NodeViewer" event="faceTalk&node_id=`$msg.node_id`&npc_id=`$npc.npc_id`"}</li>
{/foreach}
</ul>