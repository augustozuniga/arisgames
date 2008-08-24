<?php /* Smarty version 2.6.19, created on 2008-08-14 22:09:07
         compiled from /Applications/MAMP/htdocs/aris/games/aris/Framework/Module/Login/Templates/Default/Login.tpl */ ?>
<form id="login" title="<?php echo $this->_tpl_vars['company']; ?>
 <?php echo $this->_tpl_vars['title']; ?>
" action="index.php?module=Login&site=<?php echo $this->_tpl_vars['site']; ?>
" method="post" class="blackpanel" selected="true">
	<h2>Welcome to <?php echo $this->_tpl_vars['title']; ?>
.</h2>
	<fieldset>
		<div class="blackmain">
			<div class="row">
				<label>Username</label>
				<input type="text" name="user_name" />
			</div>
			<div class="row last">
				<label>Password</label>
				<input type="password" name="password" />
			</div>
		</div>
		<input type="hidden" name="req" value="login" />
		<input type="hidden" name="location_detection" value="none" />
		<div class="submit"><input type="submit" value="Login" /></div>
	</fieldset>
</form>
<p class="help">Email <a href="mailto:djgagnon@wisc.edu">djgagnon@wisc.edu</a> with help requests or feedback.