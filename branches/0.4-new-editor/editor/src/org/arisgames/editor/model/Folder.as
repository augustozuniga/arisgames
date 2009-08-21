package org.arisgames.editor.model
{
	public class Folder
	{
		private var privateName:String;
		private var type:String;
		private var contents:Array;
		private var generator:Generator;
		
		public function Folder(name:String, type:String, generatorLabel:String):void
		{
			privateName = name;
			this.type = type;
			contents = new Array();
			generator = new Generator(generatorLabel, type);
			contents.push(generator);
		}
		
		public function get children():Array
		{
			return contents;
		}
		
		public function get label():String
		{
			return privateName;
		}
		
		public function getType():String
		{
			return type;
		}
		
		public function set children(newContents:Array):void
		{
			contents = newContents;
			contents.push(generator);
		}
		
		public function clear():void
		{
			contents = new Array();
			contents.push(generator);
		}

	}
}