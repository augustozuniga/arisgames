<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * Framework_Module_Welcome
 *
 * @author      Joe Stump <joe@joestump.net>
 * @copyright   Joe Stump <joe@joestump.net>
 * @package     Framework
 * @subpackage  Module
 * @filesource
 */

/**
 * Framework_Module_Welcome
 *
 * @author      Joe Stump <joe@joestump.net>
 * @package     Framework
 * @subpackage  Module
 */
class Framework_Module_Login extends Framework_Auth_No
{
    /**
     * __default
     *
     * @access      public
     * @return      mixed
     */
    public function __default()
    {   
    	// Try to authenticate
    	$session = Framework_Session::singleton();
    	
    	$this->pageTemplateFile = 'empty.tpl';
    	if (!empty($_POST['user_name'])) {
    		$userField = Framework::$site->config->user->userField;
    	
    		// Query the database
    		$sql = sprintf("SELECT %s, user_name, password FROM %s%s 
    			WHERE user_name='%s' AND password='%s'", 
    			$userField,
    			Framework::$site->config->aris->tablePrefix,
    			Framework::$site->config->user->userTable,
    			$_POST['user_name'], $_POST['password']);

    		$row = Framework::$db->getRow($sql);

    		if ($_POST['user_name'] == $row['user_name']
    			&& $_POST['password'] == $row['password'])
    		{
    			$session->authorization = array('user_name' => $_POST['user_name'],
    				'player_id' => $row['player_id']);
    				
    			$session->{$userField} = $row["$userField"];
    			
    			// Get the next site
    			$site = Framework::$site->name;
    			if (isset($row['site']) && !empty($row['site'])) $site = $row['site'];
    			
    			// Load Applications
    			$this->loadApplications($row['player_id']);
		    	header("Location: {$_SERVER['PHP_SELF']}?module=Quest&controller=Web&site="
		    		. $site);
    			die;
    		}
    	}
    	header("Location: {$_SERVER['PHP_SELF']}?module=Welcome&controller=Web&event=loginError&site="
    		. Framework::$site->name);
    	die;
    }
}

?>
