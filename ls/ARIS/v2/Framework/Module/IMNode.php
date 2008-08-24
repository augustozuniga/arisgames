<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * Framework_Module_IMNode
 *
 * @author      Joe Stump <joe@joestump.net>
 * @copyright   Joe Stump <joe@joestump.net>
 * @package     Framework
 * @subpackage  Module
 * @filesource
 */

/**
 * Framework_Module_IMNode
 *
 * @author      Joe Stump <joe@joestump.net>
 * @package     Framework
 * @subpackage  Module
 */
class Framework_Module_IMNode extends Framework_Auth_No
{
	public $controllers = array('JSON');

    /**
     * __default
     *
     * @access      public
     * @return      mixed
     */
    public function __default()
    {
    	// Need a node ID
    	if (!$_REQUEST['nodeID']) return "No node ID specified.";

    	$nodeID = $_REQUEST['nodeID'];
    	$npcID = $_REQUEST['npcID'];
    	
    	$this->data = $this->createMessage($nodeID, $npcID);
    }
    
    /**
     * Generates messages.
     */
    function createMessage($id, $npcID) {
    	$sql = Framework::$db->prefix("SELECT * FROM _P_nodes WHERE node_id = $id");
    	$row = Framework::$db->getRow($sql);
    	$session = Framework_Session::singleton();
    	$user = Framework_User::singleton();

    	$messages = new stdClass;
    	$messages->id = $row['node_id'];
    	$photo = ($user->photo) ? $user->photo : 'defaultUser.png';
    	$messages->player_icon = $photo;
    	
    	
    	$messages->phrases = $this->makePhrases($row);
    	$messages->options = $this->makeOptions($row, $npcID);
    	$messages->optionDelay = 1000;
    	
    	$sql = Framework::$db->prefix("SELECT * FROM _P_npcs WHERE npc_id = $npcID");
    	$row = Framework::$db->getRow($sql);
    	$messages->npc_name = $row['name'];
    	$messages->npc_icon = empty($row['media']) 
    		? 'defaultUser.png' 
    		: FRAMEWORK_WWW_BASE_PATH . '/Framework/Site/' . Framework::$site->name . '/Templates/Default/templates/' . $row['media'];
    	
    	return $messages;
    }
    
    /**
     * Generates phrases from the node.
     */
    function &makePhrases($dbRow) {
    	// We have <p>a</p><p>b</p>
    	$lines = explode('</p>', $dbRow['text']);
    	$isNPC = false;
    	$phrases = array();
    	foreach ($lines as $line) {
    		if (empty($line)) continue;
    		if (stristr($line, 'PC')) {
    			$isNPC = false;
    		}
    		else $isNPC = true;
    		$phrases[] = $this->makePhrase($isNPC, $line . "</p>", strlen($line) * mt_rand(10, 20));
    	}
    	return $phrases;
    }
    
    /**
     * Generates all of the options.
     */
    function &makeOptions($dbRow, $npcID) {
    	$options = array();
    
    	for ($i = 1; $i < 4; ++$i) {
    		if ($dbRow["opt{$i}_text"] && $dbRow["opt{$i}_node_id"]) {
    			$options[] = $this->makeOption($dbRow["opt{$i}_text"], 	
    				$dbRow["opt{$i}_node_id"]);
    		}
    	}
    	
    	if (count($options) == 0) $options = &$this->getConversations($npcID);
    	
    	return $options;
    }
    
    /**
     * TODO: Move this and the corresponding section in NodeViewer to an NPC class.
     */
    function getConversations($npcID) {
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
    	
    	$rows = Framework::$db->getAll($sql);
    	$options = Array();
    	foreach ($rows as $row) {
   			$options[] = $this->makeOption($row['text'], $row['node_id']);
   		}
   		return $options;
    }

	/**
	 * Generates phrases.
	 */
	function makePhrase($isNPC, $phrase, $delay) {
    	$utterance = new stdClass;
	    $utterance->isNPC = $isNPC;
    	$utterance->phrase = $phrase;
	    $utterance->delay = $delay;
    	return $utterance;
	}

	/**
	 * Returns the option list from the node.
	 */
	function makeOption($phrase, $queueId) {
    	$option = new stdClass;
	    $option->phrase = $phrase;
    	$option->queueId = $queueId;
	    return $option;
	}
}

?>
