{if $success}
	<p>Enter three items you noticed during your trip to Dotty's</p>
	<p>Do not think too long, simply type in the first things that come to mind.</p>
	<form method="post" action="{$smarty.server.REQUEST_URI}">
		<p>Thing 1: <input type = "text" name = "item1"></p>
		<p>Thing 2: <input type = "text" name = "item2"></p>
		<p>Thing 3: <input type = "text" name = "item3"></p>
		<input type="hidden" name="handler" value="part3"/>
		<input type="submit" name="button" id="button" value="Submit Responses" />
	</form>

{else}
	<h2>You have not gone to the location we asked. </h2>
	<p>This discrepancy was recored in your profile</p>
	<p>Click the button below when you have reached Dotty's<p>
	{link text="I am now at Dotty's" module=Profile event="part2"}
			
{/if}