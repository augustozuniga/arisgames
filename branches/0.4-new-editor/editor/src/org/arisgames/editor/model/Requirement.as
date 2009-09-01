package org.arisgames.editor.model
{
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	[Bindable]
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
		public static const ADD:String = "addRequirement";
		public static const DELETE:String = "deleteRequirement";
		public static const MODIFY:String = "modifyRequirement";
		
		public var requirementTypesDataProvider:ArrayCollection;
		
		private var ref:GameObjectReference;
		private var code:int;
		private var reqID:int;
		private var eventID:int;
		
		public function Requirement(objRef:GameObjectReference, code:int, reqID:int, eventID:int)
		{
			this.ref = objRef;
			this.code = code;
			this.reqID = reqID;
			this.eventID = eventID;
			if(ref.getType() == GameObjectReference.ITEM)
			{
				this.requirementTypesDataProvider = new ArrayCollection(REQUIREMENT_TYPES_ITEM);
			}
			else if(ref.getType() == GameObjectReference.PAGE)
			{
				this.requirementTypesDataProvider = new ArrayCollection(REQUIREMENT_TYPES_PAGE);
			}
		}
		
		public function copy():Requirement
		{
			return new Requirement(this.ref, this.code, this.reqID, this.eventID);
		}
		
		public function differs(altReq:Requirement):Boolean
		{
			return (this.requirementType != altReq.requirementType);
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
		
		public function getDBCode():String
		{
			if(ref.getType() == GameObjectReference.ITEM)
			{
				if(code == 0)
				{
					return HAS_ITEM;
				}
				if(code == 1)
				{
					return DOES_NOT_HAVE_ITEM;
				}
				code -= 2;
			}
			if(code == 0)
			{
				return HAS_EVENT;
			}
			return DOES_NOT_HAVE_EVENT;
		}
		
		public function getEventCode():String
		{
			var evtCode:String;
			if(ref.getType() == GameObjectReference.ITEM)
			{
				if(code < 2)
				{
					return null;
				}
				evtCode = GameObjectReference.ITEM;
			}
			else if(ref.getType() == GameObjectReference.PAGE)
			{
				evtCode = GameObjectReference.PAGE;
			}
			else
			{
				Alert.show("error in Requirement.getEventCode() - unsupported object type");
			}
			evtCode += getObjectID().toString();
			return evtCode;
		}
		
		public function getObjectID():int
		{
			if(ref.getType() == GameObjectReference.ITEM && code < 2)
			{
				return ref.getID();
			}
			return eventID;
		}
		
		public function getObjectType():String
		{
			return ref.getType();
		}
		
		public function getRequirementID():int
		{
			return this.reqID;
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