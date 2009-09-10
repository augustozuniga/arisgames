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
		
		public function addGPSInstance(newInstance:GPSInstance):void
		{
			gpsInstances.push(newInstance);
			addCounter++;
		}
		
		public function addQRCodeInstance(newInstance:QRCodeInstance):void
		{
			qrInstances.push(newInstance);
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
			for each(var gpsInstance:GPSInstance in gpsInstances)
			{
				var gpsInstanceFound:Boolean = false;
				var gpsInstanceIndex:int = 0;
				while(!gpsInstanceFound && gpsInstanceIndex < gpsInstancesSnapshot.length)
				{
					if((gpsInstancesSnapshot[gpsInstanceIndex] as GPSInstance).getInstanceID() == gpsInstance.getInstanceID())
					{
						gpsInstanceFound = true;
					}
					else
					{
						gpsInstanceIndex++;
					}
				}
				if(gpsInstanceFound)
				{
					if((gpsInstancesSnapshot[gpsInstanceIndex] as GPSInstance).differs(gpsInstance))
					{
						differences.push(GPSInstance.MODIFY + gpsInstance.getInstanceID().toString());
					}
					gpsInstancesSnapshot.splice(gpsInstanceIndex, 1); // this is the line that destroys the snapshot fidelity
															   // it is here to increase performance
															   // if you remove it, make sure to adjust the next for each to compensate
				}
				else
				{
					differences.push(GPSInstance.ADD + gpsInstance.getInstanceID());
				}
			}
			for each(var remainingGPSInstance:GPSInstance in gpsInstancesSnapshot)
			{
				differences.push(GPSInstance.DELETE + remainingGPSInstance.getInstanceID());
			}
			return differences;
		}
		
		public function getGPSInstance(id:int):GPSInstance
		{
			for each(var instance:GPSInstance in gpsInstances)
			{
				if(instance.getInstanceID() == id)
				{
					return instance;
				}
			}
			return null;			
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
		
		public function removeGPSInstance(instance:GPSInstance):void
		{
			gpsInstances.splice(gpsInstances.indexOf(instance), 1);
		}
		
		public function removeQRCodeInstance(instance:QRCodeInstance):void
		{
			qrInstances.splice(qrInstances.indexOf(instance), 1);
		}
		
		override public function takeSnapshot():void
		{
			super.takeSnapshot();
			qrInstancesSnapshot = new Array();
			for each(var qrInstance:QRCodeInstance in qrInstances)
			{
				qrInstancesSnapshot.push(qrInstance.copy());
			}
			gpsInstancesSnapshot = new Array();
			for each(var gpsInstance:GPSInstance in gpsInstances)
			{
				gpsInstancesSnapshot.push(gpsInstance.copy());
			}
		}
	}
}