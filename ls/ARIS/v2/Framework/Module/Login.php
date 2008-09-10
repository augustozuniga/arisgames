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
    		$sql = sprintf("SELECT * FROM %s 
    			WHERE user_name='%s' AND password='%s'", 
    			Framework::$site->config->user->userTable,
    			$_POST['user_name'], $_POST['password']);
    		$row = Framework::$db->getRow($sql);
    		if ($_POST['user_name'] == $row['user_name']
    			&& $_POST['password'] == $row['password'])
    		{
    			$session->authorization = array('user_name' => $_POST['user_name'],
    				"$userField" => $row["$userField"]);
    				
    			$session->{$userField} = $row["$userField"];
    			
    			// Prepare the next site
    			Framework::$site = Framework_Site::factory($row['site']);
    			Framework::$site->prepare();
    			$this->site = Framework::$site->name;
    			
    			// Load Applications
    			$this->loadApplications($row["$userField"]);
				$this->defaultModule = Framework::$site->config->aris->main->defaultModule;
				header("Location: {$_SERVER['PHP_SELF']}?module={$this->defaultModule}&controller=Web&site="
					. $this->site);
				die;
    		}
    	}
    	header("Location: {$_SERVER['PHP_SELF']}?module=Welcome&controller=Web&event=loginError&site="
    		. Framework::$site->name);
    	die;
    }
}

?>
