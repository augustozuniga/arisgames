package org.arisgames.editor.model
{
	import mx.collections.ArrayCollection;
	
	public class Page extends GameObject
	{
		public var choicesArrayCollection:ArrayCollection;
		public var modificationsArrayCollection:ArrayCollection;
		
		private var choices:Array;
		private var playerModifications:Array;
		
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
			choices.push(newChoice);
			choicesArrayCollection.itemUpdated(choices);
		}
		
		public function addPlayerModification(newModification:PlayerModification):void
		{
			playerModifications.push(newModification);
			modificationsArrayCollection.itemUpdated(playerModifications);
		}
		
		public function getChoices():Array
		{
			return choices;
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
		
	}
}