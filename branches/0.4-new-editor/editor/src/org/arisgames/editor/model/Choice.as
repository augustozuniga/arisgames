package org.arisgames.editor.model
{
	public class Choice
	{
		private var ref:GameObjectReference;
		private var text:String;
		
		public function Choice(objRef:GameObjectReference, text:String)
		{
			this.ref = objRef;
			this.text = text;
		}
		
		public function get label():String
		{
			return ref.label;
		}
		
		public function get choiceText():String
		{
			return text;
		}

	}
}