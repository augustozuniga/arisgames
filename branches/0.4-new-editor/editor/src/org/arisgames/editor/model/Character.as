package org.arisgames.editor.model
{
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class Character extends GameObject
	{
		public var choicesArrayCollection:ArrayCollection;
		
		private var choices:Array;
		private var greeting:String;
		
		public function Character(reference:GameObjectReference,
							 	  description:String, 
							 	  media:String,
							 	  requirements:Array,
							 	  choices:Array)
		{
			super(reference, description, media, requirements);
			this.choices = choices;
			this.choicesArrayCollection = new ArrayCollection(this.choices);
		}
		
		public function addChoice(newChoice:Choice):void
		{
			choices.push(newChoice);
			choicesArrayCollection.itemUpdated(choices);
		}
		
		public function getChoices():Array
		{
			return choices;
		}
		
		public function removeChoice(choice:Choice):void
		{
			choices.splice(choices.indexOf(choice), 1);
			choicesArrayCollection.itemUpdated(choices);
		}		
	}
}