<?php /* Smarty version 2.6.19, created on 2008-08-15 11:00:21
         compiled from /Applications/MAMP/htdocs/aris/games/aris/Framework/Module/Welcome/Templates/Default/Welcome.tpl */ ?>
<form id="login" title="<?php echo $this->_tpl_vars['company']; ?>
 <?php echo $this->_tpl_vars['title']; ?>
" action="index.php?module=Login&site=<?php echo $this->_tpl_vars['site']; ?>
" method="post" class="blackpanel" selected="true" target="_self">
	<h2><?php if (isset ( $this->_tpl_vars['error'] )): ?><?php echo $this->_tpl_vars['error']; ?>
<?php else: ?>Welcome to <?php echo $this->_tpl_vars['title']; ?>
.<?php endif; ?></h2>
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
<?php if (isset ( $this->_tpl_vars['techEmail'] )): ?>
<p class="help">Email <a href="mailto:<?php echo $this->_tpl_vars['techEmail']; ?>
"><?php echo $this->_tpl_vars['techEmail']; ?>
</a> with help requests or feedback.</p>
<?php endif; ?>