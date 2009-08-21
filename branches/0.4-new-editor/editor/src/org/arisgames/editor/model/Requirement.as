package org.arisgames.editor.model
{
	public class Requirement
	{	
		private var ref:GameObjectReference;
		private var type:String;
		
		public function Requirement(objRef:GameObjectReference, type:String)
		{
			this.ref = objRef;
			this.type = type;
		}
		
		public static function getSourceType(req:String):String
		{
			if(req == "HAS_ITEM" || req == "DOES_NOT_HAVE_ITEM")
			{
				return GameObjectReference.ITEM;
			}
			else
			{
				return null;
			}
		}
		
		public function get label():String
		{
			return ref.label;
		}
		
		public function get requirementType():String
		{
			return type;
		}

	}
}