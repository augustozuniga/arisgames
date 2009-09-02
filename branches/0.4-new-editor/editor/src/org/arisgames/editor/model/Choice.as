package org.arisgames.editor.model
{
	import mx.controls.Alert;
	
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
			if(this.ref.getType() != GameObjectReference.PAGE)
			{
				Alert.show("Error in Choice constructor: reference is not of type GameObjectReference.PAGE");
			}
		}
		
		public function copy():Choice
		{
			return new Choice(this.ref, this.text);
		}
		
		public function differs(altChoice:Choice):Boolean
		{// note that we don't need to check the type since only pages can be choices...
			return (this.text != altChoice.choiceText || this.ref.getID() != altChoice.ref.getID());
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