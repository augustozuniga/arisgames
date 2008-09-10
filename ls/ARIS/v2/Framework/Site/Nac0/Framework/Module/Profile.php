<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * Framework_Module_Profile
 *
 * @author      David Gagnon <djgagnon at wisc dot edu>
 * @package     Framework
 * @subpackage  Module
 * @filesource
 */
class Framework_Module_Profile extends Framework_Auth_User
{
	
	/**
     * __default
     *
     * @access      public
     * @return      mixed
     */

    public function __default()
    {
		$this->title = "Profile Description";
		
		//Profile app icon clicked, begin where they left off
		if ($this->checkForEvent(Framework_User::singleton()->player_id, Framework::$site->config->aris->profileModule->part1Event)) $this->part1();
		if ($this->checkForEvent(Framework_User::singleton()->player_id, Framework::$site->config->aris->profileModule->part2Event)) $this->part2();
		if ($this->checkForEvent(Framework_User::singleton()->player_id, Framework::$site->config->aris->profileModule->part3Event)) $this->part3();
		if ($this->checkForEvent(Framework_User::singleton()->player_id, Framework::$site->config->aris->profileModule->part4Event)) $this->part4();
		if ($this->checkForEvent(Framework_User::singleton()->player_id, Framework::$site->config->aris->profileModule->successEvent)) $this->part5('success');
		if ($this->checkForEvent(Framework_User::singleton()->player_id, Framework::$site->config->aris->profileModule->failureEvent)) $this->part5('failure');

		
		//Check if we are returning from a form
		if (isset($_REQUEST['handler'])) switch ($_REQUEST['handler']){ 
			case 'part1': 
				$this->part1();
				break;
			case 'part2': 
				$this->part2();
				break;
			case 'part3': 
				$this->part3();
				break;
			case 'part4': 
				$this->part4();
				break;	
			case 'part5': 
				$this->part5();
				break;		
		}
		
		
    }
	
	
	
	/**
     * Displays profile part 1 
     *
     * @access      protected
     */
    protected function part1()
    {
		$this->tplFile = Framework_Template::getPath('Profile_part1.tpl','Profile') . '/Profile_part1.tpl';
		$this->title = "Profile: Part 1";
		$this->addEvent(Framework_User::singleton()->player_id, Framework::$site->config->aris->profileModule->part1Event);
		
		//Add GPS Application ot User
		$this->addPlayerApplication(Framework_User::singleton()->player_id, Framework::$site->config->aris->profileModule->gpsApplicationID);

    }

	
	
	/**
     * Displays profile part 2 
     *
     * @access      protected
     */
    protected function part2()
    {
		$this->tplFile = Framework_Template::getPath('Profile_part2.tpl','Profile') . '/Profile_part2.tpl';
		$this->addEvent(Framework_User::singleton()->player_id, Framework::$site->config->aris->profileModule->part2Event);
	
		//Check for player location at dotty's
		if ($this->checkForEvent(Framework_User::singleton()->player_id, Framework::$site->config->aris->profileModule->locationEvent)) {
			$this->setData('success', TRUE);
			$this->title = "Profile: Part 2";
			$this->removePlayerApplication(Framework_User::singleton()->player_id, Framework::$site->config->aris->profileModule->gpsApplicationID);
		}
		else {
			$this->setData('success', FALSE);
			$this->title = "Issue Recorded";
		}
    }	

	
	
	/**
     * Displays profile part 3 
     *
     * @access      protected
     */
    protected function part3()
    {
		$this->tplFile = Framework_Template::getPath('Profile_part1.tpl','Profile') . '/Profile_part3.tpl';
		$this->title = "Profile: Part 3";
		$this->addEvent(Framework_User::singleton()->player_id, Framework::$site->config->aris->profileModule->part3Event);
		
    }	
	
	
	
	/**
     * Displays profile part 4 
     *
     * @access      protected
     */
    protected function part4()
    {
		$this->tplFile = Framework_Template::getPath('Profile_part1.tpl','Profile') . '/Profile_part4.tpl';
		$this->title = "Profile: Part 4";
		$this->addEvent(Framework_User::singleton()->player_id, Framework::$site->config->aris->profileModule->part4Event);
		
		if (isset($_REQUEST['feelings'])) {
		switch ($_REQUEST['feelings']) {
			case '1':
				$this->setData('personalityType', 'VyGot 2 Personality Type');
				break;
			case '2':
				$this->setData('personalityType', 'VyGot 4 Personality Type');
				break;
			case '3':
				$this->setData('personalityType', 'VyGot 9 Personality Type');
				break;
			case '4':
				$this->setData('personalityType', 'VyGot 3 Personality Type');
				break;
			default:
				$this->setData('personalityType', 'VyGot 1 Personality Type');
		}
		}
		else $this->setData('personalityType', 'VyGot 1 Personality Type');
		
    }	
	
	
	
	/**
     * Displays profile part 5 
     *
     * @access      protected
     */
    protected function part5($previous_set_event = null)
    {
		$this->tplFile = Framework_Template::getPath('Profile_part1.tpl','Profile') . '/Profile_part5.tpl';
		$this->title = "Assessment Complete";
		
		if ($previous_set_event == 'success' or (isset($_REQUEST['code']) and $_REQUEST['code'] == 'rachael')) {
				$this->setData('succes', TRUE);
				$this->addEvent(Framework_User::singleton()->player_id, Framework::$site->config->aris->profileModule->successEvent);
		}
		else {
				$this->setData('success', FALSE);		
				$this->addEvent(Framework_User::singleton()->player_id, Framework::$site->config->aris->profileModule->failureEvent);
		}
	}
	
}

?>
