{if $location.media}
<div class="locationImg">
	<img src="{$location.media}" />
	<p>{$location.description}</p>
</div>
{/if}
<div class="locationCaption">Nearby People or Objects</div>
{include file="$frameworkModulePath/contactList.tpl"}
