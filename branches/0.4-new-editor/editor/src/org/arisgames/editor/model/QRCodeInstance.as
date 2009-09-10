package org.arisgames.editor.model
{
	import org.arisgames.editor.view.QRCodeMarker;
	
	public class QRCodeInstance extends GameObjectInstance
	{
		public static const ADD:String = "addQRCodeInstance";
		public static const DELETE:String = "deleteQRCodeInstance";
		public static const MODIFY:String = "modifyQRCodeInstance";
		public static const MAX_CODE:int = 10000;

		private var marker:QRCodeMarker;
		private var xPos:Number;
		private var yPos:Number;
		
		public function QRCodeInstance(ref:GameObjectReference, instanceID:int, xPos:Number, yPos:Number)
		{
			super(ref, instanceID, GameObjectInstance.QRCODE);
			this.marker = null;
			this.xPos = xPos;
			this.yPos = yPos;
		}
		
		public function copy():GameObjectInstance
		{
			return new QRCodeInstance(this.ref, this.privateID, getXPos(), getYPos());
		}
		
		public function differs(altInstance:QRCodeInstance):Boolean
		{
			return (   (this.getXPos() != altInstance.getXPos())
					|| (this.getYPos() != altInstance.getYPos())
					);
		}
		
		public function getMarker():QRCodeMarker
		{
			return this.marker;
		}
		
		public function getXPos():Number
		{
			if(marker == null)
			{
				return xPos;
			}
			else
			{
				return marker.x;
			}
		}
		
		public function getYPos():Number
		{
			if(marker == null)
			{
				return yPos;
			}
			else
			{
				return marker.y;
			}
		}
		
		public function makeMarker():void
		{
			this.marker = new QRCodeMarker(this);
			this.marker.x = xPos;
			this.marker.y = yPos;
		}
		
	}
}