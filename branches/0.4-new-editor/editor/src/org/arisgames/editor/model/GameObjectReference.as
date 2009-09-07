package org.arisgames.editor.model
{
	public class GameObjectReference
	{
		public static const CHARACTER:String = "Npc";
		public static const ITEM:String = "Item";
		public static const PAGE:String = "Node";
		public static const QUEST:String = "Quest";
		public static const MEDIA:String = "Media";
		
		private var privateID:int;
		private var privateName:String;
		private var privateType:String;
		
		public function GameObjectReference(id:int, type:String, name:String):void
		{
			privateID = id;
			privateType = type;
			privateName = name;
		}
		
		public function get label():String
		{
			return privateName;
		}
		
		public function getID():int
		{
			return privateID;
		}
		
		public function getType():String
		{
			return privateType;
		}
		
		public function set label(newLabel:String):void
		{
			privateName = newLabel;
		}
		
		public function isMedia():Boolean
		{ // this function is included for possible extensions that distinguish between media types
			return (privateType == MEDIA);
		}

	}
}