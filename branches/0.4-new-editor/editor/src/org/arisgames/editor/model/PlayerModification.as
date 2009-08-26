package org.arisgames.editor.model
{
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	public class PlayerModification
	{
		public static const DB_CODES:Array = ["GIVE_ITEM", "TAKE_ITEM"];
		public static const MODIFICATION_TYPES:Array = ["give the player", "take from the player"];
		
		public var modificationTypesDataProvier:ArrayCollection;
		
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
			this.modificationTypesDataProvier = new ArrayCollection(DB_CODES);
		}
		
		public function get label():String
		{
			return ref.label;
		}
		
		public function get modificationType():String
		{
			return type;
		}

	}
}