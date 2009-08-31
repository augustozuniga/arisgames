package org.arisgames.editor.model
{
	import mx.collections.ArrayCollection;
	
	[Bindable]
	public class Character extends GameObject
	{
		public var choicesArrayCollection:ArrayCollection;
		
		private var choices:Array;
		private var greeting:String;
		
		private var choicesSnapshot:Array;
		private var greetingSnapshot:String;
		
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
		
		override public function getDifferences():Array
		{
			var differences:Array = super.getDifferences();
			if(differences.indexOf(GameObject.MODIFY) < 0 && greeting != greetingSnapshot)
			{
				differences.push(GameObject.MODIFY);
			}
			for each(var obj:Choice in choices)
			{
				var choiceFound:Boolean = false;
				var choiceIndex:int = 0;
				while(!choiceFound && choiceIndex < choicesSnapshot.length)
				{
					if((choicesSnapshot[choiceIndex] as Choice).getID() == obj.getID())
					{
						choiceFound = true;
					}
					else
					{
						choiceIndex++;
					}
				}
				if(choiceFound)
				{
					if((choicesSnapshot[choiceIndex] as Choice).differs(obj))
					{
						differences.push(Choice.MODIFY + obj.getID().toString());
					}
					choicesSnapshot.splice(choiceIndex, 1); // this is the line that destroys the snapshot fidelity
															   // it is here to increase performance
															   // if you remove it, make sure to adjust the next for each to compensate
				}
				else
				{
					differences.push(Choice.ADD + obj.getID());
				}
			}
			for each(var remainingChoice:Choice in choicesSnapshot)
			{
				differences.push(Choice.DELETE + remainingChoice.getID());
			}
			return differences;
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

		override public function takeSnapshot():void
		{
			super.takeSnapshot();
			greetingSnapshot = greeting;
			choicesSnapshot = new Array();
			for each(var obj:Choice in choices)
			{
				choicesSnapshot.push(obj.copy());
			}
		}
		
	}
}