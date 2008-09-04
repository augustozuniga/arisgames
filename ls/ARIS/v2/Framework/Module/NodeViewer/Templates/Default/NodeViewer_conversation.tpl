<iframe id="chatFrame" src="{$frameworkTplPath}/dialogcontainer.html"></iframe>

<input id="message" value=" " disabled="true" />
<input type="button" id="playerMessageSendButton" value="Send" disabled="true" onclick="postPlayerMessage();"/>
<div id="rawMessage"></div>
<script language="JavaScript" type="text/javascript">
<!--
{foreach from=$conversations item=msg}
	prepOptions({$msg.node_id}, "{$msg.text|strip}");
{/foreach}
//-->
</script>