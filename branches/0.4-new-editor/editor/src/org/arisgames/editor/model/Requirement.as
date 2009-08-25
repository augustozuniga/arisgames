package org.arisgames.editor.model
{
	import mx.controls.Alert;
	
	public class Requirement
	{	
		public static const DOES_NOT_HAVE_EVENT:String = "DOES_NOT_HAVE_EVENT";
		public static const DOES_NOT_HAVE_ITEM:String = "DOES_NOT_HAVE_ITEM";
		public static const HAS_EVENT:String = "HAS_EVENT";
		public static const HAS_ITEM:String = "HAS_ITEM";
		public static const REQUIREMENT_TYPES_ITEM:Array = ["currently has", "does not currently have", "has ever looked at", "has never looked at"];
		public static const REQUIREMENT_TYPES_PAGE:Array = ["has seen", "has never seen"];
		
		private var ref:GameObjectReference;
		private var code:int;
		
		public function Requirement(objRef:GameObjectReference, code:int)
		{
			this.ref = objRef;
			this.code = code;
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

	}
}