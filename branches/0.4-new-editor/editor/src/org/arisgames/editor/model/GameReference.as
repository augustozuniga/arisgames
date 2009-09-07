package org.arisgames.editor.model
{	
	public class GameReference
	{
		private static var currentModel:Model;
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
		
		public static function init(model:Model):void
		{
			currentModel = model;
		}
		
		public function set name(newName:String):void
		{
			if(currentModel != null)
			{
				currentModel.renameGame(privateID, newName);
			}
		}
		
		public function getID():int
		{
			return privateID;
		}

	}
}