package org.arisgames.editor.model
{
	public class Choice
	{
		public static const ADD:String = "addChoice";
		public static const DELETE:String = "deleteChoice";
		public static const MODIFY:String = "modifyChoice";
		
		private var ref:GameObjectReference;
		private var text:String;
		
		public function Choice(objRef:GameObjectReference, text:String)
		{
			this.ref = objRef;
			this.text = text;
		}
		
		public function copy():Choice
		{
			return new Choice(this.ref, this.text);
		}
		
		public function differs(altChoice:Choice):Boolean
		{
			return (this.text != altChoice.choiceText);
		}
		
		public function get label():String
		{
			return ref.label;
		}
		
		public function get choiceText():String
		{
			return text;
		}
		
		public function getID():int
		{
			return ref.getID();
		}
		
		public function set choiceText(newText:String):void
		{
			text = newText;
		}

	}
}