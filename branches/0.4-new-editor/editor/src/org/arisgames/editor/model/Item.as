package org.arisgames.editor.model
{
	import mx.collections.ArrayCollection;
	
	public class Item extends GameObject
	{
		public var modificationsArrayCollection:ArrayCollection;

		private var droppable:Boolean;
		private var destroyable:Boolean;
		private var playerModifications:Array;
		
		private var droppableSnapshot:Boolean;
		private var destroyableSnapshot:Boolean;
		private var playerModificationsSnapshot:Array;
		
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
		
		override public function getDifferences():Array
		{
			var differences:Array = super.getDifferences();
			if(differences.indexOf(GameObject.MODIFY) < 0
				&& (droppable != droppableSnapshot || destroyable != destroyableSnapshot))
			{
				differences.push(GameObject.MODIFY);
			}
			for each(var mod:PlayerModification in playerModifications)
			{
				var found:Boolean = false;
				var index:int = 0;
				while(!found && index < playerModificationsSnapshot.length)
				{
					if((playerModificationsSnapshot[index] as PlayerModification).getModID() == mod.getModID())
					{
						found = true;
					}
					else
					{
						index++;
					}
				}
				if(found)
				{
					if((playerModificationsSnapshot[index] as PlayerModification).differs(mod))
					{
						differences.push(PlayerModification.MODIFY + mod.getModID().toString());
					}
					playerModificationsSnapshot.splice(index, 1); // this is the line that destroys the snapshot fidelity
															   // it is here to increase performance
															   // if you remove it, make sure to adjust the next for each to compensate
				}
				else
				{
					differences.push(PlayerModification.ADD + mod.getModID());
				}
			}
			for each(var remainingMod:PlayerModification in playerModificationsSnapshot)
			{
				differences.push(PlayerModification.DELETE + remainingMod.getModID());
			}
			return differences;
		}
		
		public function getModification(modID:int):PlayerModification
		{
			for each(var mod:PlayerModification in playerModifications)
			{
				if(mod.getModID() == modID)
				{
					return mod;
				}
			}
			return null;
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
		
		override public function takeSnapshot():void
		{
			super.takeSnapshot();
			destroyableSnapshot = destroyable;
			droppableSnapshot = droppable;
			playerModificationsSnapshot = new Array();
			for each(var mod:PlayerModification in playerModifications)
			{
				playerModificationsSnapshot.push(mod.copy());
			}
		}
		
	}
}