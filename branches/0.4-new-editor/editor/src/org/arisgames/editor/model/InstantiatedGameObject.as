package org.arisgames.editor.model
{
	public class InstantiatedGameObject extends GameObject
	{
		private var qrInstances:Array;
		private var gpsInstances:Array;
		
		private var qrInstancesSnapshot:Array;
		private var gpsInstancesSnapshot:Array;
		
		public function InstantiatedGameObject(reference:GameObjectReference, description:String, media:String, requirements:Array)
		{
			super(reference, description, media, requirements);
			this.qrInstances = new Array();
			this.gpsInstances = new Array();
		}
		
		public function addQRCodeInstance(newInstance:QRCodeInstance):void
		{
			qrInstances.push(newInstance);
			addCounter++;
		}
		
		override public function getDifferences():Array
		{
			var differences:Array = super.getDifferences();
			for each(var qrInstance:QRCodeInstance in qrInstances)
			{
				var qrInstanceFound:Boolean = false;
				var qrInstanceIndex:int = 0;
				while(!qrInstanceFound && qrInstanceIndex < qrInstancesSnapshot.length)
				{
					if((qrInstancesSnapshot[qrInstanceIndex] as QRCodeInstance).getInstanceID() == qrInstance.getInstanceID())
					{
						qrInstanceFound = true;
					}
					else
					{
						qrInstanceIndex++;
					}
				}
				if(qrInstanceFound)
				{
					if((qrInstancesSnapshot[qrInstanceIndex] as QRCodeInstance).differs(qrInstance))
					{
						differences.push(QRCodeInstance.MODIFY + qrInstance.getInstanceID().toString());
					}
					qrInstancesSnapshot.splice(qrInstanceIndex, 1); // this is the line that destroys the snapshot fidelity
															   // it is here to increase performance
															   // if you remove it, make sure to adjust the next for each to compensate
				}
				else
				{
					differences.push(QRCodeInstance.ADD + qrInstance.getInstanceID());
				}
			}
			for each(var remainingQRInstance:QRCodeInstance in qrInstancesSnapshot)
			{
				differences.push(QRCodeInstance.DELETE + remainingQRInstance.getInstanceID());
			}
			return differences;
		}
		
		public function getQRCodeInstance(id:int):QRCodeInstance
		{
			for each(var instance:QRCodeInstance in qrInstances)
			{
				if(instance.getInstanceID() == id)
				{
					return instance;
				}
			}
			return null;
		}
		
		public function removeQRCodeInstance(instance:QRCodeInstance):void
		{
			qrInstances.splice(qrInstances.indexOf(instance), 1);
		}
		
		override public function takeSnapshot():void
		{
			super.takeSnapshot();
			qrInstancesSnapshot = new Array();
			for each(var instance:QRCodeInstance in qrInstances)
			{
				qrInstancesSnapshot.push(instance.copy());
			}
		}
	}
}