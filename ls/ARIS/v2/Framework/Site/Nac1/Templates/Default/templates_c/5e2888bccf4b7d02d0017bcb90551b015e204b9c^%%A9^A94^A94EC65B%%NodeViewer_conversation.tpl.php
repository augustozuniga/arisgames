<?php /* Smarty version 2.6.19, created on 2008-08-22 14:13:44
         compiled from /Applications/MAMP/htdocs/aris/games/aris/Framework/Module/NodeViewer/Templates/Default/NodeViewer_conversation.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('modifier', 'strip', '/Applications/MAMP/htdocs/aris/games/aris/Framework/Module/NodeViewer/Templates/Default/NodeViewer_conversation.tpl', 9, false),)), $this); ?>
<iframe id="chatFrame" src="<?php echo $this->_tpl_vars['frameworkTplPath']; ?>
/dialogcontainer.html"></iframe>

<div id="message">&nbsp;</div>
<input type="button" id="playerMessageSendButton" value="Send" onclick="postPlayerMessage();"/>
<div id="rawMessage"></div>
<script language="JavaScript" type="text/javascript">
<!--
<?php $_from = $this->_tpl_vars['conversations']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['msg']):
?>
	prepOptions(<?php echo $this->_tpl_vars['msg']['node_id']; ?>
, "<?php echo ((is_array($_tmp=$this->_tpl_vars['msg']['text'])) ? $this->_run_mod_handler('strip', true, $_tmp) : smarty_modifier_strip($_tmp)); ?>
");
<?php endforeach; endif; unset($_from); ?>
//-->
</script>