package org.arisgames.editor.model
{
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	public class Requirement extends EventDispatcher
	{	
		public static const DOES_NOT_HAVE_EVENT:String = "DOES_NOT_HAVE_EVENT";
		public static const DOES_NOT_HAVE_ITEM:String = "DOES_NOT_HAVE_ITEM";
		public static const HAS_EVENT:String = "HAS_EVENT";
		public static const HAS_ITEM:String = "HAS_ITEM";
		public static const QUEST_COMPLETE:String = "QuestComplete";
		public static const QUEST_DISPLAY:String = "QuestDisplay";
		public static const REQUIREMENT_TYPES_ITEM:Array = ["currently has", "does not currently have", "has ever looked at", "has never looked at"];
		public static const REQUIREMENT_TYPES_PAGE:Array = ["has seen", "has never seen"];
		
		[Bindable] public var requirementTypesDataProvider:ArrayCollection;
		
		private var ref:GameObjectReference;
		private var code:int;
		
		public function Requirement(objRef:GameObjectReference, code:int)
		{
			this.ref = objRef;
			this.code = code;
			if(ref.getType() == GameObjectReference.ITEM)
			{
				this.requirementTypesDataProvider = new ArrayCollection(REQUIREMENT_TYPES_ITEM);
			}
			else if(ref.getType() == GameObjectReference.PAGE)
			{
				this.requirementTypesDataProvider = new ArrayCollection(REQUIREMENT_TYPES_PAGE);
			}
		}
		
		public function get label():String
		{
			return ref.label;
		}
		
		public function get requirementType():String
		{
			var type:String = ref.getType();
			if(type == GameObjectReference.ITEM)
			{
				return REQUIREMENT_TYPES_ITEM[code];
			}
			if(type == GameObjectReference.PAGE)
			{
				return REQUIREMENT_TYPES_PAGE[code];
			}
			Alert.show("Error in Requirement.requirementType: bad object type");
			return null;			
		}
		
		public function set requirementType(newType:String):void
		{
			var objType:String = ref.getType();
			var sourceArray:Array;
			if(objType == GameObjectReference.ITEM)
			{
				sourceArray = REQUIREMENT_TYPES_ITEM;
			}
			else if(objType == GameObjectReference.PAGE)
			{
				sourceArray = REQUIREMENT_TYPES_PAGE;
			}
			else
			{
				Alert.show("Error in Requirement.requirementType: bad object type");
				return;
			}
			var newCode:int = sourceArray.indexOf(newType);
			if(newCode >= 0)
			{
				this.code = newCode;
			}
			else
			{
				Alert.show("Error in Requirement.requirementType: bad requirement type");
			}
		}
		
	}
}