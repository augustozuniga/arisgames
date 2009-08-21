package org.arisgames.editor.model
{
	public class Quest extends GameObject
	{
		private var objectives:Array;
		
		public function Quest(reference:GameObjectReference,
							  description:String, 
							  media:String,
							  requirements:Array,
							  objectives:Array)
		{
			super(reference, description, media, requirements);
			this.objectives = objectives;
		}
		
		public function addObjective(newObjective:Requirement):void
		{
			objectives.push(newObjective);
		}
		
		public function getObjectives():Array
		{
			return objectives;
		}
		
		public function removeObjective(objective:Requirement):void
		{
			objectives.splice(objectives.indexOf(objective), 1);
		}		
	}
}