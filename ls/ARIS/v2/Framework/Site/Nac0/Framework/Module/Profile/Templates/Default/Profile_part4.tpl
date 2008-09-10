<p>Thank you for your telling response. So far you have the attributes of a: </p>
<h2>{$personalityType}</h2>	

<p>Your last task involves human interaction.</p>
<p>Go inside and talk with the bartender. Tell him you want to know who the "burger princess" is and give him a dollar bill. 
He will give you the code-word to enter below.</p>
<h3>Type carefully, you will have only once chance to enter the code.</h3>

<form method="post" action="{$smarty.server.REQUEST_URI}">
	<p>Code Word: <input name="code" type="text"></p>
	<input type="hidden" name="handler" value="part5"/>
	<input type="submit" name="submit" id="submit" value="Submit Code" />
</form>
<br/><br/><hr/>