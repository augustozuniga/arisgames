<?php /* Smarty version 2.6.19, created on 2008-08-14 09:11:07
         compiled from /Applications/MAMP/htdocs/aris/games/aris/Framework/Module/Welcome/Templates/Default/Welcome_error.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('function', 'link', '/Applications/MAMP/htdocs/aris/games/aris/Framework/Module/Welcome/Templates/Default/Welcome_error.tpl', 3, false),)), $this); ?>
<?php echo $this->_tpl_vars['error']; ?>


foo <?php echo smarty_function_link(array('module' => 'Test','text' => 'yay'), $this);?>