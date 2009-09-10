package org.arisgames.editor.model
{
	import mx.controls.Alert;
	
	public class GPSInstance extends GameObjectInstance
	{
		public static const ADD:String = "addGPSInstance";
		public static const DELETE:String = "deleteGPSInstance";
		public static const MODIFY:String = "modifyGPSInstance";
		
		public function GPSInstance(ref:GameObjectReference, instanceID:int)
		{
			super(ref, instanceID, GameObjectInstance.GPS);
		}
		
		public function copy():GPSInstance
		{
			return new GPSInstance(this.ref, this.privateID);
		}
		
		public function differs(altInstance:GPSInstance):Boolean
		{
			Alert.show("GPSInstance.differs not yet implemented");
			return false;
		}
		
	}
}