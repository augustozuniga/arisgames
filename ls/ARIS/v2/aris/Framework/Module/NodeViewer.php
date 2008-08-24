<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * Framework_Module_Main
 *
 * @author      Kevin Harris <klharris2@wisc.edu>
 * @copyright   Joe Stump <joe@joestump.net>
 * @package     Framework
 * @subpackage  Module
 * @filesource
 */

/**
 * Framework_Module_NodeViewer
 *
 * @author      Kevin Harris <klharris2@wisc.edu>
 * @package     Framework
 * @subpackage  Module
 */
class Framework_Module_NodeViewer extends Framework_Auth_User
{
    /**
     * __default
     *
     * This sets up the contact list.
     *
     * @access      public
     * @return      void
     */
    public function __default()
    {
    	$user = Framework_User::singleton();
    
    	$this->title = sprintf(Framework::$site->config->aris->nodeViewer->title, 
    		$user->user_name);
    	$this->company = Framework::$site->config->aris->company;
    	
    	$sql = Framework::$db->prefix("SELECT * FROM _P_npcs
			WHERE location_id = '0' 
				AND (require_event_id IS NULL or require_event_id IN 
					(SELECT event_id FROM _P_player_events 
						WHERE player_id = {$user->player_id}))");
		$this->npcs = Framework::$db->getAll($sql);
    }
    
    /**
     * listConversations
     *
     * List all of the conversations available for the given 
     * NPC and player.
     * 
     * @access		public
     * @return		void
     */
    public function conversation()
    {
    	$session = Framework_Session::singleton();
    	$user = Framework_User::singleton();
    
    	// Ensure that we have an id
    	if (!$_REQUEST['npc_id']) throw new Framework_Exception('Unauthorized link.', FRAMEWORK_ERROR_AUTH);
    	$npcID = $_REQUEST['npc_id'];
    	
    	$sql = Framework::$db->prefix("SELECT name FROM _P_npcs WHERE npc_id = $npcID");
    	$npc = Framework::$db->getRow($sql);
    	
    	// Relative to the JS file?
    	$photo = ($user->photo) ? $user->photo : 'defaultUser.png';
    	
    	$site = Framework::$site->name;
    	$wwwBase = FRAMEWORK_WWW_BASE_PATH;
    	
    	$this->title = $npc['name'];
    	$this->scripts = array('im.js');
    	$this->rawHead = <<<SCRIPT
   <script type="application/x-javascript">
   <!--
    var site = "$site";
    var wwwBase = "$wwwBase";
   	npcID = $npcID;
   	messageQueue['player_icon'] = "$photo";
   	messageQueue['options'] = new Array();
   //-->
   </script>
   
SCRIPT;
    	
    	$sql = Framework::$db->prefix(
    	"SELECT * FROM _P_npc_conversations 
			WHERE  
				(require_event_id IS NULL OR require_event_id IN 
					(SELECT event_id FROM _P_player_events WHERE player_id = $_SESSION[player_id])) 
			AND
				(require_location_id IS NULL OR require_location_id IN 
					(SELECT last_location_id FROM _P_players WHERE player_id = $_SESSION[player_id])) 
			AND
				(_P_npc_conversations.remove_if_event_id IS NULL 
					OR _P_npc_conversations.remove_if_event_id NOT IN 
						(SELECT event_id FROM _P_player_events WHERE player_id = $_SESSION[player_id]))
			AND	npc_id = $npcID
			ORDER BY node_id DESC"
    	);
    	
    	$this->conversations = Framework::$db->getAll($sql);
    }
}

?>
