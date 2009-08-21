package org.arisgames.editor.model
{
	public class PlayerModification
	{
		private var ref:GameObjectReference;
		private var type:String;
		
		public function PlayerModification(objRef:GameObjectReference, type:String)
		{
			this.ref = objRef;
			this.type = type;
		}
		
		public function get label():String
		{
			return ref.label;
		}
		
		public function get modificationType():String
		{
			return type;
		}

	}
}