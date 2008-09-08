<?php
	
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
	
	define('DEFAULT_IMAGE', 'defaultInventory.png');
	
	/**
	 * Framework_Module_Inventory
	 *
	 * @author      Kevin Harris <klharris2@wisc.edu>
	 * @author		David Gagnon <djgagnon@wisc.edu>
	 * @package     Framework
	 * @subpackage  Module
	 */
	class Framework_Module_Inventory extends Framework_Auth_User
	{
		/**
		 * __default
		 *
		 * Shows the list of items for a player
		 *
		 * @access      public
		 * @return      mixed
		 */
		public function __default()
		{
			$site = Framework::$site;
			$user = Framework_User::singleton();
			
			$this->title = $site->config->aris->inventory->title;
			$this->loadInventory($user->player_id);
		}
		
		protected function loadInventory($userID) {
			$sql = $this->db->prefix("SELECT * FROM _P_items
									 JOIN _P_player_items 
									 ON _P_items.item_id = _P_player_items.item_id
									 WHERE player_id = $userID");
			$inventory = $this->db->getAll($sql);
			
			//groom media
			foreach ($inventory as &$item) {
				//Use defaults if specified media cannot be found
				$media = empty($item['media']) ? DEFAULT_IMAGE : $item['media'];
				$item['media'] = $this->findMedia($media, DEFAULT_IMAGE);
				
				//Set additional isImage var in array so template knows how to link to it
				//if isImage var is false, the link go go directly to the media file (used for mp3, mp4, etc) to support iphone
				$extension = substr(strrchr($item['media'], "."), 1);
				if (array_search($extension,array("png", "jpg", "gif")) === FALSE) {
					$item['isImage'] = FALSE;
					$item['media'] = 'http://' . $_SERVER["SERVER_NAME"] . $item['media'];
				}
				else $item['isImage'] = TRUE;
			}
			unset($item);
			
			$this->inventory = $inventory;
		}
		
		public function displayItem(){
			if (empty($_REQUEST['item_id'])) {
				$this->title = "Error";
				$this->errorMessage = "Item cannot be viewed at this time.";
				return;
			}
			$itemID = $_REQUEST['item_id'];
			
			// Load the item data
			$sql = Framework::$db->prefix("SELECT * FROM _P_items WHERE item_id = $itemID");
			$this->item = Framework::$db->getRow($sql);
			
			//Set the title
			$this->title = $this->item['name'];
			
			//Check if an image was specified and can be found, if not, load the default
			$this->media = $this->findMedia($this->item['media'], DEFAULT_IMAGE);
						
			
		}
		
		
	}
	?>
