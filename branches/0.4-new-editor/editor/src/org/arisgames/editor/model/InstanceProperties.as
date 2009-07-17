package org.arisgames.editor.model
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
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

		private var titleField:TextField;
		private var hiddenPicLoader:Loader;
		private var visiblePicLoader:Loader;
		private var visibilityIndicator:Sprite;
		private var forceViewPicLoader:Loader;
		private var optionalViewPicLoader:Loader;
		private var viewModeIndicator:Sprite;
		private var deleteBox:Sprite;
		private var contentDisplay:Sprite;		
		
		public function InstanceProperties(sourceObject:InstantiatedObject, initiallyHidden:Boolean = false, forceView:Boolean = true, quantity:int = 1):void
		{
			hiddenPicLoader = new Loader()
			hiddenPicLoader.load(new URLRequest("assets/editor icons/hidden.png"));
			visiblePicLoader = new Loader();
			visiblePicLoader.load(new URLRequest("assets/editor icons/visible.png"));
			visibilityIndicator = new Sprite();
			visibilityIndicator.addEventListener(MouseEvent.CLICK, updateVisibilityIndicator);
			forceViewPicLoader = new Loader();
			forceViewPicLoader.load(new URLRequest("assets/editor icons/exclamationPoint.png"));
			optionalViewPicLoader = new Loader();
			optionalViewPicLoader.load(new URLRequest("assets/editor icons/parentheses.png"));
			viewModeIndicator = new Sprite();
			viewModeIndicator.addEventListener(MouseEvent.CLICK, updateViewModeIndicator);
			titleField = new TextField();
			deleteBox = new Sprite();
			var deleteField:TextField = new TextField();
			deleteField.text = "Delete this copy";
			deleteField.x = deleteField.textHeight;
			deleteField.height = deleteField.textHeight + 5;
			deleteField.width = deleteField.textWidth + 20;
			deleteField.selectable = false;
			deleteBox.graphics.lineStyle(3, 0xFF0000);
			deleteBox.graphics.moveTo(2, 2);
			deleteBox.graphics.lineTo(deleteField.textHeight - 2, deleteField.textHeight - 2);
			deleteBox.graphics.moveTo(deleteField.textHeight - 2, 2);
			deleteBox.graphics.lineTo(2, deleteField.textHeight - 2);			
			deleteBox.addChild(deleteField);
			deleteBox.addEventListener(MouseEvent.CLICK, deleteMe);
			this.sourceObject = sourceObject;
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
		
		public function getGameMarker():GameObjectMarker
		{
			return gpsMarker;
		}
		
		public function getSourceObject():InstantiatedObject
		{
			return this.sourceObject;
		}
		
		public function setGameMarker(newMarker:GameObjectMarker):void
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
			titleField.text = getSourceObject().getName();
			titleField.x = 0;
			titleField.y = 0;
			titleField.width = titleField.textWidth + 20;
			titleField.height = titleField.textHeight + 5;
			contentDisplay.addChild(titleField);
			updateVisibilityIndicator();
			visibilityIndicator.x = 0;
			visibilityIndicator.y = titleField.height;
			contentDisplay.addChild(visibilityIndicator);
			updateViewModeIndicator();
			viewModeIndicator.x = visibilityIndicator.width + 5;
			viewModeIndicator.y = visibilityIndicator.y;
			contentDisplay.addChild(viewModeIndicator);
			deleteBox.x = 0;
			deleteBox.y = visibilityIndicator.y + visibilityIndicator.height + 5;
			contentDisplay.addChild(deleteBox);
			return contentDisplay;
		}
		
		private function deleteMe(event:MouseEvent = null):void
		{
			Alert.show("Are you sure you want to delete this copy of " + getSourceObject().getName() + "?  (other copies will remain in place)",
					   "Confirm Delete", (Alert.OK | Alert.CANCEL), null, doDelete, null, Alert.CANCEL);
		}
		
		private function doDelete(event:CloseEvent):void
		{
			this.getGameMarker().setFocus();
			if(event.detail == Alert.OK)
			{
				visibilityIndicator.removeEventListener(MouseEvent.CLICK, updateVisibilityIndicator);
				viewModeIndicator.removeEventListener(MouseEvent.CLICK, updateViewModeIndicator);
				deleteBox.removeEventListener(MouseEvent.CLICK, deleteMe);
				gpsMarker.deleteMe();
				gpsMarker = null;
				this.getSourceObject().removeInstance(this);				
			}
		}
		
		private function updateVisibilityIndicator(event:MouseEvent = null):void
		{
			if(event != null)
			{
				this.setInitiallyHidden(!isInitiallyHidden());
			}
			var image1:Loader;
			if(isInitiallyHidden())
			{
				image1 = hiddenPicLoader;
			}
			else
			{
				image1 = visiblePicLoader;
			}
			if(!visibilityIndicator.contains(image1))
			{
				while(visibilityIndicator.numChildren > 0)
				{
					visibilityIndicator.removeChildAt(0);
				}
				visibilityIndicator.addChild(image1);				
			}
		}

		private function updateViewModeIndicator(event:MouseEvent = null):void
		{
			if(event != null)
			{
				this.setForceView(!isViewForced());
			}
			var image1:Loader;
			if(isViewForced())
			{
				image1 = forceViewPicLoader;
			}
			else
			{
				image1 = optionalViewPicLoader;
			}
			if(!viewModeIndicator.contains(image1))
			{
				while(viewModeIndicator.numChildren > 0)
				{
					viewModeIndicator.removeChildAt(0);
				}
				viewModeIndicator.addChild(image1);				
			}
		}

	}
}