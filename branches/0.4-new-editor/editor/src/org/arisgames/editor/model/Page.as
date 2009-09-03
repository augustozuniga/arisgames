package org.arisgames.editor.model
{
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	public class Page extends GameObject
	{
		public static const MAX_NUM_CHOICES:int = 3;
		
		public var choicesArrayCollection:ArrayCollection;
		public var modificationsArrayCollection:ArrayCollection;
		
		private var choices:Array;
		private var playerModifications:Array;
		
		private var choicesSnapshot:Array;
		private var playerModificationsSnapshot:Array;
		
		public function Page(reference:GameObjectReference,
							 description:String, 
							 media:String,
							 requirements:Array,
							 playerModifications:Array,
							 choices:Array)
		{
			super(reference, description, media, requirements);
			this.playerModifications = playerModifications;
			this.modificationsArrayCollection = new ArrayCollection(this.playerModifications);
			this.choices = choices;
			this.choicesArrayCollection = new ArrayCollection(this.choices);
		}
		
		public function addChoice(newChoice:Choice):void
		{
			if(choices.length < MAX_NUM_CHOICES)
			{
				choices.push(newChoice);
				choicesArrayCollection.itemUpdated(choices);
				addCounter++;
			}
			else
			{
				Alert.show("A Page cannot contain more than three choices");
			}
		}
		
		public function addPlayerModification(newModification:PlayerModification):void
		{
			playerModifications.push(newModification);
			modificationsArrayCollection.itemUpdated(playerModifications);
			addCounter++;
		}
		
		public function getChoices():Array
		{
			return choices;
		}
		
		override public function getDifferences():Array
		{
			var differences:Array = super.getDifferences();
			if(differences.indexOf(GameObject.MODIFY) < 0)
			{
				if(choices.length != choicesSnapshot.length)
				{
					differences.push(GameObject.MODIFY);
				}
				else
				{
					var i:int = 0;
					while(i < choices.length)
					{
						if((choicesSnapshot[i] as Choice).differs(choices[i] as Choice))
						{
							differences.push(GameObject.MODIFY);
							i = MAX_NUM_CHOICES;
						}
						i++;
					}					
				}
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
		
		public function removeChoice(choice:Choice):void
		{
			choices.splice(choices.indexOf(choice), 1);
			choicesArrayCollection.itemUpdated(choices);
		}
		
		public function removePlayerModification(mod:PlayerModification):void
		{
			playerModifications.splice(playerModifications.indexOf(mod), 1);
			modificationsArrayCollection.itemUpdated(playerModifications);
		}
		
		override public function takeSnapshot():void
		{
			super.takeSnapshot();
			playerModificationsSnapshot = new Array();
			for each(var mod:PlayerModification in playerModifications)
			{
				playerModificationsSnapshot.push(mod.copy());
			}
			choicesSnapshot = new Array();
			for each(var obj:Choice in choices)
			{
				choicesSnapshot.push(obj.copy());
			}
		}
		
	}
}