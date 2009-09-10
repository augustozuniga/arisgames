package org.arisgames.editor.model
{
	import org.arisgames.editor.controller.Controller;
	
	public class GameObjectInstance
	{
		public static const GPS:String = "gpsInstance";
		public static const QRCODE:String = "qrCodeInstance";
		
		protected var ref:GameObjectReference;
		protected var privateID:int;
		protected var instanceType:String;
		
		public function GameObjectInstance(ref:GameObjectReference, instanceID:int, instanceType:String)
		{
			this.ref = ref;
			this.privateID = instanceID;
			this.instanceType = instanceType;
		}
		
		public function belongsToGameObject(obj:GameObject):Boolean
		{
			return (   (obj.getID() == ref.getID())
					&& (obj.getType() == ref.getType())
					);
		}
		
		public function getInstanceID():int
		{
			return this.privateID;
		}
		
		public function getInstanceType():String
		{
			return this.instanceType;
		}
		
		public function getObjectID():int
		{
			return ref.getID();
		}
		
		public function getObjectName():String
		{
			return ref.label;
		}
		
		public function getObjectType():String
		{
			return ref.getType();
		}

	}
}