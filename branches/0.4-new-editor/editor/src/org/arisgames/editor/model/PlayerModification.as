package org.arisgames.editor.model
{
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	[Bindable]
	public class PlayerModification
	{
		public static const DB_CODES:Array = ["GIVE_ITEM", "TAKE_ITEM"];
		public static const MODIFICATION_TYPES:Array = ["give the player", "take from the player"];
		public static const ADD:String = "addModification";
		public static const DELETE:String = "deleteModification";
		public static const MODIFY:String = "modifyModification";
		
		public var modificationTypesDataProvider:ArrayCollection;
		
		private var ref:GameObjectReference;
		private var type:String;
		private var modID:int;
		
		public function PlayerModification(objRef:GameObjectReference, typeCode:String, modID:int)
		{
			this.ref = objRef;
			this.modID = modID;
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
		
		public function copy():PlayerModification
		{
			return new PlayerModification(this.ref, this.getDBCode(), this.modID);
		}
		
		public function differs(altMod:PlayerModification):Boolean
		{
			return (type != altMod.modificationType);
		}
		
		public function get label():String
		{
			return ref.label;
		}
		
		public function get modificationType():String
		{
			return type;
		}
		
		public function getDBCode():String
		{
			return DB_CODES[MODIFICATION_TYPES.indexOf(this.type)];
		}
		
		public function getItemID():int
		{
			return ref.getID();
		}
		
		public function getModID():int
		{
			return this.modID;
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