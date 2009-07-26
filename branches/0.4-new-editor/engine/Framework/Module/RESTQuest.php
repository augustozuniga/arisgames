<?php

include_once "RESTLoginLib.php";

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * Framework_Module_Main
 *
 * @author      Kevin Harris <klharris2@wisc.edu>
 * @author		David Gagnon <djgagnon@wisc.edu>
 * @copyright   Joe Stump <joe@joestump.net>
 * @package     Framework
 * @subpackage  Module
 * @filesource
 */

define('DEFAULT_IMAGE', 'defaultQuest.png');

/**
 * Framework_Module_Quest
 *
 * @author      Kevin Harris <klharris2@wisc.edu>
 * @author		David Gagnon <djgagnon@wisc.edu>
 * @package     Framework
 * @subpackage  Module
 */
class Framework_Module_RESTQuest extends Framework_Auth_User
{
    /**
     * __default
     *
     * Displays a map, we didn't come here with a location to display
     *
     * @access      public
     * @return      mixed
     */
    public function __default() {
    	
    	$user = loginUser();
    	
    	if(!$user) {
    		header("Location: {$_SERVER['PHP_SELF']}?module=RESTError&controller=Web&event=loginError&site=" . Framework::$site->name);
    		die;
    	}
    	
    	$site = Framework::$site;
    	
    	$this->title = $site->config->aris->quest->title;
    	$this->chromeless = true;
    			
		$sql = $this->db->prefix("SELECT * FROM _P_quests
								 ORDER BY _P_quests.quest_id ASC");
		$quests = $this->db->getAll($sql);
		
		//Groom Media
		foreach ($quests as &$quest) {
			$media = empty($quest['media']) ? DEFAULT_IMAGE : $quest['media'];
			$quest['media'] = $this->findMedia($media, DEFAULT_IMAGE);
		}
		
		//Either put it in $this->activeQuests or $this->completedQuests
		$activeQuests = array();
		$completedQuests = array(); 
		foreach ($quests as &$quest) {
			if ($this->objectMeetsRequirements ($user, "Quest", $quest['quest_id'])) $completedQuests[] = $quest;
			else $activeQuests[] = $quest;
		}
		$this->activeQuests = $activeQuests;
		$this->completedQuests = $completedQuests; 
		
	}
}
?>
