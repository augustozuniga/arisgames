<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * RESTNodeManager
 *
 * @author      Kevin Harris <klharris2@wisc.edu>
 * @package     Framework
 * @subpackage  Module
 * @filesource
 */

/**
 * RESTNodeManager
 *
 * Encapsulates all node loading, requirements, etc.
 *
 * @author      Kevin Harris <klharris2@wisc.edu>
 * @author 		David Gagnon <djgagnon@wisc.edu>
 * @package     Framework
 * @subpackage  Module
 */
class RESTNodeManager
{
	/** 
	 * $node
     * 
     * @access public
     * @var object $module The fully-processed node object
     * @static
	 */
	static public $node = null;
	static public $npc = null;
	static public $conversations = null;
	static public $messages = array();
	static public $user = null;

	static public function loadNode($nodeID, $npcID = 0) {
		
		$user = loginUser();
		self::$user = $user;
		$userID = $user['player_id'];
		
		//Load the NPC
		$sql = Framework::$db->prefix("SELECT * FROM _P_npcs WHERE npc_id = '$npcID'");
    	self::$npc = Framework::$db->getRow($sql);

		//echo 'Manager: Begin loading node: ' . $nodeID . '<br/>';
		//echo 'User Data:<br/>';
		//var_dump ($user);
		
		if (!empty($_REQUEST['answer_string'])) {
			$nodeID = self::checkQuestionNode($nodeID);
		}
	
		$sql = Framework::$db->prefix("SELECT * FROM _P_nodes 
			WHERE node_id = '$nodeID'");
    	
		//echo '<p>Manager: DB Call to fetch row begin:</p>';
		
		$row = Framework::$db->getRow($sql);
		
    	if (!$row) {
    		// TODO: Change this to an appropriate exception.
			throw new Framework_Exception('Communication disrupted.', 
	    		FRAMEWORK_ERROR_AUTH);
    	}


    	self::$node = $row;
		
		//echo '<p>Manager: self::$node set. Here is the data:</p>';
		//var_dump(self::$node);

    	if (self::$node['add_item_id']) {
    		Framework_Module::giveItemToPlayer($userID, self::$node['add_item_id']);
    	}

    	if (self::$node['remove_item_id']) {
    		Framework_Module::takeItemFromPlayer($userID, self::$node['remove_item_id']);
    	}

    	if (self::$node['add_event_id']) {
			Framework_Module::addEvent($userID, self::$node['add_event_id']);
    	}
		
		if (self::$node['remove_event_id']) {
			Framework_Module::removePlayerEvent($userID, self::$node['remove_event_id']);
    	}

		// NOTE: calling methods should check for 'require_answer_string' 
		// to handle input
    	
		if (empty(self::$node['require_answer_string'])) {
    		if ((!empty(self::$node['opt1_text']) && !empty(self::$node['opt1_node_id']))
    			|| (!empty(self::$node['opt2_text']) && !empty(self::$node['opt2_node_id']))
    			|| (!empty(self::$node['opt3_text']) && !empty(self::$node['opt3_node_id']))) { 
					self::loadOptions($npcID); 
			}
    		
    		if ($npcID > 0 && is_null(self::$conversations)) {
    			//echo '<p>Manager: loadNodeConversations for NPC: '. $npcID . '</p>';
				self::loadConversations($npcID);
				
    		}
    	}
		
		//echo 'Maager: Ending LoadNode(). Self Node Data:<br/>';
		//var_dump(self::$node);
	}
	
	/**
     * Returns the correct question-result node or the REQUEST node
     * if not a question.
     *
     * @returns int
     */
    static protected function checkQuestionNode($nodeID) {
   		$sql = Framework::$db->prefix("SELECT * FROM _P_nodes 
   			WHERE node_id='$nodeID'");
    	$row = Framework::$db->getRow($sql);
    		
		if (!$row) {
			// TODO: Change this to an appropriate exception.
			throw new Framework_Exception('Communication terminated.', 
    			FRAMEWORK_ERROR_AUTH);
    	}
    		
    	if (strtolower(trim($_REQUEST['answer_string']))
    		== strtolower($row['require_answer_string']))
    	{
    		// Correct answer
    		$nodeID = $row['require_answer_correct_node_id'];
    	}
		else { 
			// Incorrect answer
			$nodeID = $row['required_condition_not_met_node_id'];
   		}
    	
    	return $nodeID;
    }
    
    static public function loadConversations($npcID) {
    	$user = loginUser();
		self::$user = $user;
		$session = Framework_Session::singleton();
		
		// Ensure that we have an id
    	// TODO: Change to an appropriate exception
    	if (empty($npcID)) throw new Framework_Exception('Unauthorized link.',
    		FRAMEWORK_ERROR_AUTH);
    	
		
    	$sql = Framework::$db->prefix("SELECT * FROM _P_npcs WHERE npc_id = $npcID");
    	self::$npc = Framework::$db->getRow($sql);

		//Fetch conversations for this NPC
    	$sql = Framework::$db->prefix(
    	"SELECT * FROM _P_npc_conversations 
			WHERE npc_id = $npcID
			ORDER BY node_id DESC"
    	);
		$conversations = Framework::$db->getAll($sql);
    	
		//Check each conversation for their requirements
		foreach ($conversations as $conversationkey => $conversation) {
			//echo "Checking Conversation: {$conversation['conversation_id']} for Node: {$conversation['node_id']} ";
			if (!Framework_Module::objectMeetsRequirements (self::$user, 'Node', $conversation['node_id'])) unset ($conversations[$conversationkey]);
			//else echo " - PASSES"; 
		}
		
    	self::$conversations = $conversations;    
    }
    
    static public function loadOptions($npcID) {
    	if (!empty($npcID) && $npcID > 0) {
	    	$sql = Framework::$db->prefix("SELECT * FROM _P_npcs WHERE npc_id = $npcID");
    		self::$npc = Framework::$db->getRow($sql);
    	}
    	else {
    		self::$npc = array('name' => self::$node['title'], 'npc_id' => -1,
    		'media' => self::$node['media']);
    	}
    
    
    	$results = array();
    	$r = self::loadOption($results, 'opt1_text', 'opt1_node_id');
    	$r = self::loadOption($results, 'opt2_text', 'opt2_node_id');
    	$r = self::loadOption($results, 'opt3_text', 'opt3_node_id');
    	
    	self::$conversations = $results;
    }
    
    static public function loadOption(&$target, $text, $id) {
	    if (!empty(self::$node[$text]) && 
			!empty(self::$node[$id]) &&
			Framework_Module::objectMeetsRequirements (self::$user, 'Node', self::$node[$id])) {
			
			$id = self::$node[$id];
			$text = self::$node[$text];
			$optionDetails = array('text' => $text, 'node_id' => $id, 'npc_id' => -1);
				array_push($target, $optionDetails);
    	}
    }
}
?>
