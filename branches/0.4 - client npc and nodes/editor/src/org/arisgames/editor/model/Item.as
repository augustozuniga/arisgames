package org.arisgames.editor.model
{
	import mx.collections.ArrayCollection;
	
	public class Item extends GameObject
	{
		public var modificationsArrayCollection:ArrayCollection;

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
			this.modificationsArrayCollection = new ArrayCollection(this.playerModifications);
			this.droppable = droppable;
			this.destroyable = destroyable;
		}
		
		public function addPlayerModification(newModification:PlayerModification):void
		{
			playerModifications.push(newModification);
			modificationsArrayCollection.itemUpdated(playerModifications);
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
			modificationsArrayCollection.itemUpdated(playerModifications);
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