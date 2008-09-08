<!--
<iframe id="chatFrame" src="{$frameworkTplPath}/dialogcontainer.html"></iframe>
-->
<!-- <div id="chatFrame"> -->
	<table id="dialog" width="295px">
		<tr><td><div style="padding-top: 10px; font-style: italic;">Chat started.</div></td></tr>
	</table>
<!-- </div> -->
<input id="message" value=" " disabled="true" />
<select id="playerMessageSelection" onchange="postSelection();">
	<option value="">Say...</option>
</select>
<input type="button" id="playerMessageSendButton" value="Send" disabled="true" onclick="postPlayerMessage();"/>
	<div id="viewAnchor" style="height: 20px;"></div>
<div id="rawMessage"></div>
<script language="JavaScript" type="text/javascript">
<!--
{foreach from=$conversations item=msg}
	prepOptions({$msg.node_id}, "{$msg.text|strip}");
	startOptions();
{/foreach}
//-->
</script>