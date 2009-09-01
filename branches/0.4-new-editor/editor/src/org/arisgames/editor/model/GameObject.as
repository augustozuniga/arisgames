package org.arisgames.editor.model
{
	import mx.collections.ArrayCollection;
	
	// IMPORTANT: This class is functionally ABSTRACT.  Do not instantiate directly!
	// Instead, use a subclass: Character, Item, Page, or Quest
	
	[Bindable]
	public class GameObject
	{
		public static const MODIFY:String = "modifyObject";
		
		public var requirementsArrayCollection:ArrayCollection;
		
		private var ref:GameObjectReference;
		private var description:String;
		private var media:String;
		private var requirements:Array;
		
		//snapshot properties
		private var nameSnapshot:String;
		private var descriptionSnapshot:String;
		private var mediaSnapshot:String;
		private var requirementsSnapshot:Array;
		
		public function GameObject(reference:GameObjectReference, description:String, media:String, requirements:Array)
		{
			this.ref = reference;
			this.description = description;
			this.media = media;
			this.requirements = requirements;
			this.requirementsArrayCollection = new ArrayCollection(this.requirements);
		}
		
		public function addRequirement(newRequirement:Requirement):void
		{
			requirements.push(newRequirement);
		}
		
		public function getID():int
		{
			return ref.getID();
		}
		
		public function getName():String
		{
			return ref.label;
		}
		
		public function getDescription():String
		{
			return description;
		}
		
		//NOTE THAT AS IMPLEMENTED, THIS FUNCTION DESTROYS THE FIDELITY OF THE SNAPSHOT!!
		public function getDifferences():Array
		{
			var differences:Array = new Array();
			if(this.ref.label != nameSnapshot || this.description != descriptionSnapshot || this.media != mediaSnapshot)
			{
				differences.push(GameObject.MODIFY);
			}
			for each(var req:Requirement in requirements)
			{
				var found:Boolean = false;
				var index:int = 0;
				while(!found && index < requirementsSnapshot.length)
				{
					if((requirementsSnapshot[index] as Requirement).getRequirementID() == req.getRequirementID())
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
					if((requirementsSnapshot[index] as Requirement).differs(req))
					{
						differences.push(Requirement.MODIFY + req.getRequirementID().toString());
						requirementsSnapshot.splice(index, 1); // this is the line that destroys the snapshot fidelity
															   // it is here to increase performance
															   // if you remove it, make sure to adjust the next for each to compensate
					}
				}
				else
				{
					differences.push(Requirement.ADD + req.getRequirementID());
				}
			}
			for each(var remainingReq:Requirement in requirementsSnapshot)
			{
				differences.push(Requirement.DELETE + remainingReq.getRequirementID());
			}
			return differences;
		}
		
		public function getMediaFileName():String
		{
			return media;
		}
		
		public function getReference():GameObjectReference
		{
			return ref;
		}
		
		public function getRequirement(reqID:int):Requirement
		{
			for each(var req:Requirement in requirements)
			{
				if(req.getRequirementID() == reqID)
				{
					return req;
				}
			}
			return null;
		}
		
		public function getRequirements():Array
		{
			return requirements;
		}
		
		public function getType():String
		{
			return this.ref.getType();
		}
		
		public function removeRequirement(req:Requirement):void
		{
			requirements.splice(requirements.indexOf(req), 1);
		}
		
		public function setDescription(newDescription:String):void
		{
			this.description = newDescription;
		}
		
		public function setName(newName:String):void
		{
			this.ref.label = newName;
		}
		
		public function takeSnapshot():void
		{
			nameSnapshot = ref.label;
			descriptionSnapshot = description;
			mediaSnapshot = media;
			requirementsSnapshot = new Array();
			for each(var req:Requirement in requirements)
			{
				requirementsSnapshot.push(req.copy());
			}			
		}

		public function updateName(newName:String):void
		{
			ref.label = newName;
		}
		
		public function updateDescription(newDescription:String):void
		{
			description = newDescription;
		}
		
		public function updateMedia(newMedia:GameObjectReference):void
		{
			if(newMedia.isMedia());
			{
				media = newMedia.label;
			}
		}

	}
}