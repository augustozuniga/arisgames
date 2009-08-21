package org.arisgames.editor.model
{
	public class Item extends GameObject
	{
		private var droppable:Boolean;
		private var destroyable:Boolean;
		private var playerModifications:Array;
		
		public function Item(reference:GameObjectReference,
							 description:String, 
							 media:String,
							 requirements:Array,
							 playerModifications:Array,
							 droppable:Boolean,
							 destroyable:Boolean)
		{
			super(reference, description, media, requirements);
			this.playerModifications = playerModifications;
			this.droppable = droppable;
			this.destroyable = destroyable;
		}
		
		public function addPlayerModification(newModification:PlayerModification):void
		{
			playerModifications.push(newModification);
		}
		
		public function getPlayerModifications():Array
		{
			return playerModifications;
		}
		
		public function isDestroyable():Boolean
		{
			return destroyable;
		}
		
		public function isDroppable():Boolean
		{
			return droppable;
		}
		
		public function removePlayerModification(mod:PlayerModification):void
		{
			playerModifications.splice(playerModifications.indexOf(mod), 1);
		}
		
		public function setDestroyable(newValue:Boolean):void
		{
			destroyable = newValue;
		}
		
		public function setDroppable(newValue:Boolean):void
		{
			droppable = newValue;
		}
		
	}
}