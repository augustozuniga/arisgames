package org.arisgames.editor.model
{
	public class GameObjectInstance
	{
		public static const ADD:String = "addInstance";
		public static const DELETE:String = "deleteInstance";
		public static const MODIFY:String = "modifyInstance";
		
		private var ref:GameObjectReference;
		private var privateID:int;
		
		public function GameObjectInstance(ref:GameObjectReference, instanceID:int)
		{
			this.ref = ref;
			this.privateID = instanceID;
		}
		
		public function copy():GameObjectInstance
		{
			return new GameObjectInstance(this.ref, this.privateID);
		}
		
		public function differs(instanceToCompare:GameObjectInstance):Boolean
		{
			return false;
		}
		
		public function getInstanceID():int
		{
			return this.privateID;
		}
		
		public function getObjectType():String
		{
			return ref.getType();
		}

	}
}