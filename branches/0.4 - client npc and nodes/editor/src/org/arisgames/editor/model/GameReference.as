package org.arisgames.editor.model
{
	public class GameReference
	{
		private var privateID:int;
		private var privateName:String;
		
		public function GameReference(id:int, name:String):void
		{
			privateID = id;
			privateName = name;
		}
		
		public function get name():String
		{
			return privateName;
		}
		
		public function getID():int
		{
			return privateID;
		}

	}
}