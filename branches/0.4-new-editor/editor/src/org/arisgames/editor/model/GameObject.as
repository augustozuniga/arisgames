package org.arisgames.editor.model
{
	import mx.collections.ArrayCollection;
	
	// IMPORTANT: This class is functionally ABSTRACT.  Do not instantiate directly!
	// Instead, use a subclass: Character, Item, Page, or Quest
	
	[Bindable]
	public class GameObject
	{
		public var requirementsArrayCollection:ArrayCollection;
		
		private var ref:GameObjectReference;
		private var description:String;
		private var media:String;
		private var requirements:Array;
		
		public function GameObject(reference:GameObjectReference, description:String, media:String, requirements:Array)
		{
			this.ref = reference;
			this.description = description;
			this.media = media;
			this.requirements = requirements;
		}
		
		public function addRequirement(newRequirement:Requirement):void
		{
			requirements.push(newRequirement);
		}
		
		public function getName():String
		{
			return ref.label;
		}
		
		public function getDescription():String
		{
			return description;
		}
		
		public function getMediaFileName():String
		{
			return media;
		}
		
		public function getRequirements():Array
		{
			return requirements;
		}
		
		public function removeRequirement(req:Requirement):void
		{
			requirements.splice(requirements.indexOf(req), 1);
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