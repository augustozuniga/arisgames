package org.arisgames.editor.model
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	import org.arisgames.editor.view.GameObjectMarker;
	
	public class InstanceProperties
	{
		protected var gpsMarker:GameObjectMarker;
		protected var initiallyHidden:Boolean;
		protected var forceView:Boolean;
		protected var qrCode:int;
		protected var qrCodeSet:Boolean;
		protected var quantity:int;
		protected var sourceObject:InstantiatedObject;

/*		private var hiddenPicLoader:Loader = null;
		private var visiblePicLoader:Loader = null;
		private var visibilityIndicator:Sprite;
		private var contentDisplay:Sprite;
*/		
		public function InstanceProperties(sourceObject:InstantiatedObject, initiallyHidden:Boolean = false, forceView:Boolean = true, quantity:int = 1):void
		{
/*			hiddenPicLoader = new Loader()
			hiddenPicLoader.load(new URLRequest("assets/editor icons/hidden.png"));
			visiblePicLoader = new Loader();
			visiblePicLoader.load(new URLRequest("assets/editor icons/hidden.png"));
			visibilityIndicator = new Sprite();
*/			this.sourceObject = sourceObject;
			this.gpsMarker = null;
			this.qrCode = -1;
			this.qrCodeSet = false;
			this.initiallyHidden = initiallyHidden;
			this.forceView = forceView;
			setQuantity(quantity);			
		}
						
		public function hasGPSLocation():Boolean
		{
			return (gpsMarker != null);
		}
		
		public function getMarker():GameObjectMarker
		{
			return gpsMarker;
		}
		
		public function getSourceObject():InstantiatedObject
		{
			return this.sourceObject;
		}
		
		public function setGPSMarker(newMarker:GameObjectMarker):void
		{
			if(this.gpsMarker == null)
			{
				this.gpsMarker = newMarker;
			}
		}
		
		public function hasQRCode():Boolean
		{
			return this.qrCodeSet;
		}
		
		public function getQRCode():int
		{
			return qrCode;
		}
		
		public function setQRCode(newCode:int):void
		{
			this.qrCode = newCode;
			this.qrCodeSet = true;
		}
		
		public function removeQRCode():void
		{
			this.qrCode = -1;
			this.qrCodeSet = false;
		}
		
		public function isInitiallyHidden():Boolean
		{
			return initiallyHidden;
		}
		
		public function setInitiallyHidden(newState:Boolean):void
		{
			initiallyHidden = newState;
		}
		
		public function isViewForced():Boolean
		{
			return forceView;
		}
		
		public function setForceView(newState:Boolean):void
		{
			forceView = newState;
		}
		
		public function getQuantity():int
		{
			return this.quantity;
		}
		
		public function setQuantity(newQuantity:int):void
		{
			if(sourceObject.getType() == GameObject.ITEM)
			{
				this.quantity = newQuantity;			
			}
			else
			{
				this.quantity = 1;
			}
		}
		
		public function getContentDisplay():Sprite
		{
			var contentDisplay:Sprite = new Sprite();
			var title:TextField = new TextField();
			title.text = getSourceObject().getName();
			title.x = 0;
			title.y = 0;
			title.width = title.textWidth + 20;
			title.height = title.textHeight + 5;
			contentDisplay.addChild(title);
/*			visibilityIndicator = new Sprite();
			var image1:Loader;
			if(initiallyHidden)
			{
				image1 = hiddenPicLoader;
			}
			else
			{
				image1 = visiblePicLoader;
			}
			visibilityIndicator.addChild(
			image1.x = 0;
			image1.y = title.height;
			contentDisplay.addChild(image1);
*/			return contentDisplay;
		}
		
/*		private function updateVisibilityIndicator():void
		{
			var image1:Loader;
			if(initiallyHidden)
			{
				image1 = hiddenPicLoader;
			}
			else
			{
				image1 = visiblePicLoader;
			}
//			if(visibilityIndicator.hasChild(
//			visibilityIndicator.addChild(
		}
*/

	}
}