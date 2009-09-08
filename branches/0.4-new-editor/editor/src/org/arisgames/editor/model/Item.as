package org.arisgames.editor.model
{
	import mx.collections.ArrayCollection;
	
	public class Item extends GameObject
	{
		public var modificationsArrayCollection:ArrayCollection;

		private var droppable:Boolean;
		private var destroyable:Boolean;
		private var playerModifications:Array;
		private var instances:Array;
		
		private var droppableSnapshot:Boolean;
		private var destroyableSnapshot:Boolean;
		private var playerModificationsSnapshot:Array;
		private var instancesSnapshot:Array;
		
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
			this.instances = new Array();
		}
		
		public function addInstance(newInstance:GameObjectInstance):void
		{
			instances.push(newInstance);
			addCounter++;
		}
		
		public function addPlayerModification(newModification:PlayerModification):void
		{
			playerModifications.push(newModification);
			modificationsArrayCollection.itemUpdated(playerModifications);
			addCounter++;
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
				var modFound:Boolean = false;
				var modIndex:int = 0;
				while(!modFound && modIndex < playerModificationsSnapshot.length)
				{
					if((playerModificationsSnapshot[modIndex] as PlayerModification).getModID() == mod.getModID())
					{
						modFound = true;
					}
					else
					{
						modIndex++;
					}
				}
				if(modFound)
				{
					if((playerModificationsSnapshot[modIndex] as PlayerModification).differs(mod))
					{
						differences.push(PlayerModification.MODIFY + mod.getModID().toString());
					}
					playerModificationsSnapshot.splice(modIndex, 1); // this is the line that destroys the snapshot fidelity
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
			for each(var instance:GameObjectInstance in instances)
			{
				var instanceFound:Boolean = false;
				var instanceIndex:int = 0;
				while(!instanceFound && instanceIndex < instancesSnapshot.length)
				{
					if((instancesSnapshot[instanceIndex] as GameObjectInstance).getInstanceID() == instance.getInstanceID())
					{
						instanceFound = true;
					}
					else
					{
						instanceIndex++;
					}
				}
				if(instanceFound)
				{
					if((instancesSnapshot[instanceIndex] as GameObjectInstance).differs(instance))
					{
						differences.push(GameObjectInstance.MODIFY + instance.getInstanceID().toString());
					}
					instancesSnapshot.splice(instanceIndex, 1); // this is the line that destroys the snapshot fidelity
															   // it is here to increase performance
															   // if you remove it, make sure to adjust the next for each to compensate
				}
				else
				{
					differences.push(GameObjectInstance.ADD + instance.getInstanceID());
				}
			}
			for each(var remainingInstance:GameObjectInstance in instancesSnapshot)
			{
				differences.push(GameObjectInstance.DELETE + remainingInstance.getInstanceID());
			}
			return differences;
		}
		
		public function getInstance(id:int):GameObjectInstance
		{
			for each(var instance:GameObjectInstance in instances)
			{
				if(instance.getInstanceID() == id)
				{
					return instance;
				}
			}
			return null;
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
		
		public function removeInstance(instance:GameObjectInstance):void
		{
			instances.splice(instances.indexOf(instance), 1);
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
			instancesSnapshot = new Array();
			for each(var instance:GameObjectInstance in instances)
			{
				instancesSnapshot.push(instance.copy());
			}
		}
		
	}
}