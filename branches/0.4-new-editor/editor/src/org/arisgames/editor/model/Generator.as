package org.arisgames.editor.model
{
	public class Generator
	{
		private var privateLabel:String;
		private var type:String;
		
		public function Generator(label:String, type:String)
		{
			privateLabel = label;
			this.type = type;
		}
		
		public function get label():String
		{
			return privateLabel;
		}
		
		public function getType():String
		{
			return type;
		}

	}
}