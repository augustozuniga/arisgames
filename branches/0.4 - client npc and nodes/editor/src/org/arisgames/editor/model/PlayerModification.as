package org.arisgames.editor.model
{
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	[Bindable]
	public class PlayerModification
	{
		public static const DB_CODES:Array = ["GIVE_ITEM", "TAKE_ITEM"];
		public static const MODIFICATION_TYPES:Array = ["give the player", "take from the player"];
		
		public var modificationTypesDataProvider:ArrayCollection;
		
		private var ref:GameObjectReference;
		private var type:String;
		
		public function PlayerModification(objRef:GameObjectReference, typeCode:String)
		{
			this.ref = objRef;
			var index:int = DB_CODES.indexOf(typeCode);
			if(index >= 0)
			{
				this.type = MODIFICATION_TYPES[index];		
			}
			else
			{
				Alert.show("Error in PlayerModification constructor: unrecognized typeCode");
			}
			this.modificationTypesDataProvider = new ArrayCollection(MODIFICATION_TYPES);
		}
		
		public function get label():String
		{
			return ref.label;
		}
		
		public function get modificationType():String
		{
			return type;
		}
		
		public function set modificationType(newType:String):void
		{
			var index:int;
			index = MODIFICATION_TYPES.indexOf(newType);
			if(index >= 0)
			{
				this.type = newType;
			}
			else
			{
				index = DB_CODES.indexOf(newType);
				if(index >= 0)
				{
					this.type = MODIFICATION_TYPES[index];
				}				
			}
		}

	}
}