<iframe id="chatFrame" src="{$frameworkTplPath}/dialogcontainer.html"></iframe>

<div id="message">&nbsp;</div>
<input type="button" id="playerMessageSendButton" value="Send" onclick="postPlayerMessage();"/>
<div id="rawMessage"></div>
<script language="JavaScript" type="text/javascript">
<!--
{foreach from=$conversations item=msg}
	prepOptions({$msg.node_id}, "{$msg.text|strip}");
{/foreach}
//-->
</script>