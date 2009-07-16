package org.arisgames.editor.model
{
	import org.arisgames.editor.view.GameObjectMarker;
	
	//IMPORTANT: This class is effectively ABSTRACT. Not intended for instantiation.
	//Use one the of following subclasses instead: Item, Character, Page, Quest, SecretEvent
	[Bindable]
	public class GameObject
	{
		public static const ITEM:String = "item";
		public static const CHARACTER:String = "character";
		public static const PAGE:String = "page";
		public static const QUEST:String = "quest";
		public static const SECRET_EVENT:String = "secretEvent";
		
		protected var id:int;
		protected var name:String;
		protected var notes:String;
		protected var description:String;
		protected var type:String;
		protected var media:Media;
		
//		private var mediaXMLData:XML;
//		public var mediaXMLDataProvider:XMLListCollection;

		public function GameObject(id:int, type:String):void
		{
			this.id = id;
			this.type = type;
			this.name = (type + id);
			this.notes = "";
			this.media = null;
		}
		
		public function getXML():XML
		{
			var result:XML = <object/>;
			result.@label = this.name;
			result.@id = this.id;
			result.@type = this.type;
			return result;
		}
		
		public function getID():int
		{
			return this.id;
		}
		
		public function getName():String
		{
			return this.name;
		}
		
		public function setName(newName:String):void
		{
			this.name = newName;
		}
		
		public function getType():String
		{
			return this.type;
		}
		
		public function hasMedia():Boolean
		{
			return (this.media != null);
		}
		
		public function getMedia():Media
		{
			return this.media;
		}
		
		public function setMedia(newMedia:Media):void
		{
			this.media = newMedia;
		}
		
		public function getNotes():String
		{
			return this.notes;
		}
		
		public function setNotes(newNotes:String):void
		{
			this.notes = newNotes;
		}
		
		public function getDescription():String
		{
			return this.description;
		}
		
		public function setDescription(newDescription:String):void
		{
			this.description = newDescription;
		}
		
	}
}