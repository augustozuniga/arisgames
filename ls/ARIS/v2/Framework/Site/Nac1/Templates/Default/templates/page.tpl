<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 	
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="viewport" content="width=320; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;"/>
	<title>{$title}</title>
	<link rel="stylesheet" href="{$frameworkTplPath}/iui/iui.css" type="text/css" media="all" />
	<link rel="StyleSheet" href="{$frameworkTplPath}/common.css" type="text/css" media="all" />
	
	{if isset($links)}
		{foreach from=$links item=link}
			<link rel="stylesheet" href="{$link}" type="text/css" media="all" />		
		{/foreach}
	{/if}
	<script type="application/x-javascript" src="{$frameworkTplPath}/iui/iui.js"></script>
	{if isset($scripts)}
		{foreach from=$scripts item=script}
<script type="application/x-javascript" src="{$frameworkTplPath}/{$script}"></script>
		{/foreach}
	{/if}
	{if isset($rawHead)}
		{$rawHead}
	{/if}
</head>
<body orient="portrait" {if isset($onLoad)}onload="{$onLoad}"{/if}>
<div class="toolbar black">
	<h1 id="pageTitle">{$title}</h1>
	<!-- Back button support? -->
</div>
{include file="$modulePath/$tplFile"}

{if isset($session->applications)}
<div class="appbar">
	{foreach from=$session->applications item=app}
		{application module=$app}
	{/foreach}
</div>
{/if}
</body>
</html>