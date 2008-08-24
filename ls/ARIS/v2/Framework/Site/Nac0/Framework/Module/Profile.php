<?php

/* vim: set expandtab tabstop=4 shiftwidth=4 softtabstop=4: */

/**
 * Framework_Module_Test
 *
 * @author      Kevin Harris <klharris2 at wisc dot edu>
 * @copyright   Kevin Harris <klharris2 at wisc dot edu>
 * @package     Framework
 * @subpackage  Module
 * @filesource
 */

/**
 * Framework_Module_Profile
 *
 * @author      Kevin Harris <klharris2 at wisc dot edu>
 * @copyright   Kevin Harris <klharris2 at wisc dot edu>
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
		$this->title = "Psychological Profile";
    }
}

?>
