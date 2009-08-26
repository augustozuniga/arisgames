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
							 	  choices:Array,
							 	  greeting:String)
		{
			super(reference, description, media, requirements);
			this.choices = choices;
			this.choicesArrayCollection = new ArrayCollection(this.choices);
			this.greeting = greeting;
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
		
		public function getGreeting():String
		{
			return greeting;
		}
		
		public function removeChoice(choice:Choice):void
		{
			choices.splice(choices.indexOf(choice), 1);
			choicesArrayCollection.itemUpdated(choices);
		}
		
		public function setGreeting(newText:String):void
		{
			greeting = newText;
		}
	}
}