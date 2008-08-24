<?php /* Smarty version 2.6.19, created on 2008-08-21 00:36:54
         compiled from /Applications/MAMP/htdocs/aris/games/aris/Framework/Module/NodeViewer/Templates/Default/NodeViewer.tpl */ ?>
<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('function', 'link', '/Applications/MAMP/htdocs/aris/games/aris/Framework/Module/NodeViewer/Templates/Default/NodeViewer.tpl', 6, false),)), $this); ?>
<table class="contactList">
<?php $_from = $this->_tpl_vars['npcs']; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array'); }if (count($_from)):
    foreach ($_from as $this->_tpl_vars['npc']):
?>
	<tr>
		<td>
			<?php if ($this->_tpl_vars['npc']['media']): ?>
				<?php echo smarty_function_link(array('module' => 'NodeViewer','event' => "conversation&npc_id=".($this->_tpl_vars['npc']['npc_id']),'text' => "<img src='Framework/Site/".($this->_tpl_vars['site'])."/Templates/Default/templates/".($this->_tpl_vars['npc']['media'])."' />"), $this);?>

			<?php endif; ?>
		</td>
		<td>
			<h2><?php echo smarty_function_link(array('module' => 'NodeViewer','event' => "conversation&npc_id=".($this->_tpl_vars['npc']['npc_id']),'text' => $this->_tpl_vars['npc']['name']), $this);?>
</h2>
			<p><?php echo $this->_tpl_vars['npc']['description']; ?>
</p>
		</td>	
	</tr>
<?php endforeach; endif; unset($_from); ?>
</table>