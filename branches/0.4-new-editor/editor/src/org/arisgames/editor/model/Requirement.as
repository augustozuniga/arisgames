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