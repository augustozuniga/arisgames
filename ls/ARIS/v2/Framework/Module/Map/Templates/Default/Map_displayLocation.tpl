{if $location.media}
<div class="locationImg">
	<img src="{$location.media}" />
	<p>{$location.description}</p>
</div>
{/if}

{include file="$frameworkModulePath/contactList.tpl"}
