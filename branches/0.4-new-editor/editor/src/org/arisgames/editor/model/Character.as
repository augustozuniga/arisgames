package org.arisgames.editor.model
{
	public class Character extends GameObject
	{
		private var choices:Array;
		
		public function Character(reference:GameObjectReference,
							 	  description:String, 
							 	  media:String,
							 	  requirements:Array,
							 	  choices:Array)
		{
			super(reference, description, media, requirements);
			this.choices = choices;
		}
		
		public function addChoice(newChoice:Choice):void
		{
			choices.push(newChoice);
		}
		
		public function getChoices():Array
		{
			return choices;
		}
		
		public function removeChoice(choice:Choice):void
		{
			choices.splice(choices.indexOf(choice), 1);
		}		
	}
}