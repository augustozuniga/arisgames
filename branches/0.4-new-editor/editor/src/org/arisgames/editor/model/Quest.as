package org.arisgames.editor.model
{
	import mx.collections.ArrayCollection;
	
	public class Quest extends GameObject
	{
		public var objectivesArrayCollection:ArrayCollection;
		
		private var completedDescription:String;
		private var objectives:Array;
		
		private var completedDescriptionSnapshot:String;
		private var objectivesSnapshot:Array;
		
		public function Quest(reference:GameObjectReference,
							  description:String, 
							  media:String,
							  requirements:Array,
							  objectives:Array,
							  completedDescription:String)
		{
			super(reference, description, media, requirements);
			this.objectives = objectives;
			this.completedDescription = completedDescription;
			this.objectivesArrayCollection = new ArrayCollection(this.objectives);
		}
		
		public function addObjective(newObjective:Requirement):void
		{
			objectives.push(newObjective);
			objectivesArrayCollection.itemUpdated(objectives);
		}
		
		public function getCompletedDescription():String
		{
			return completedDescription;
		}
		
		// note that this function destroys the snapshot fidelity in two ways
		override public function getDifferences():Array
		{
			var differences:Array = super.getDifferences(); // this call destroys part of the snapshot
			if(differences.indexOf(GameObject.MODIFY) < 0 && completedDescription != completedDescriptionSnapshot)
			{
				differences.push(GameObject.MODIFY);
			}
			for each(var req:Requirement in objectives)
			{
				var found:Boolean = false;
				var index:int = 0;
				while(!found && index < objectivesSnapshot.length)
				{
					if((objectivesSnapshot[index] as Requirement).getRequirementID() == req.getRequirementID())
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
					if((objectivesSnapshot[index] as Requirement).differs(req))
					{
						differences.push(Requirement.MODIFY + req.getRequirementID().toString());
					}
					objectivesSnapshot.splice(index, 1); // this line destroys part of the snapshot
															   // it is here to increase performance
															   // if you remove it, make sure to adjust the next for each to compensate
				}
				else
				{
					differences.push(Requirement.ADD + req.getRequirementID());
				}
			}
			for each(var remainingReq:Requirement in objectivesSnapshot)
			{
				differences.push(Requirement.DELETE + remainingReq.getRequirementID());
			}
			return differences;
		}
		
		public function getObjectives():Array
		{
			return objectives;
		}
		
		public function removeObjective(objective:Requirement):void
		{
			objectives.splice(objectives.indexOf(objective), 1);
			objectivesArrayCollection.itemUpdated(objectives);
		}
		
		public function setCompletedDescription(newText:String):void
		{
			completedDescription = newText;
		}
		
		override public function takeSnapshot():void
		{
			super.takeSnapshot();
			completedDescriptionSnapshot = completedDescription;
			for each(var obj:Requirement in objectives)
			{
				objectivesSnapshot.push(obj.copy());
			}
		}
	}
}