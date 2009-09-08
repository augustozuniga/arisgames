package org.arisgames.editor.view
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import mx.core.UIComponent;
	
	import org.arisgames.editor.model.QRCodeInstance;

	public class QRCodeMarker extends UIComponent
	{
		public static const QRCODEMARKER:String = "qrCodeMarker";
		
		private var infoWindow:Sprite;
		private var instance:QRCodeInstance;
		private var marker:MarkerIcon;
		private var dragging:Boolean;
		private var lastX:Number;
		private var lastY:Number;
		
		public function QRCodeMarker(instance:QRCodeInstance)
		{
			super();
			this.instance = instance;
			this.infoWindow = new Sprite();
			dragging = false;
			this.marker = new MarkerIcon(instance, this.infoWindow);
			updateInfoWindow();
			addChild(marker);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseMoveHandler);
			addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		public function mouseDownHandler(event:MouseEvent):void
		{
			dragging = true;
			lastX = event.localX;
			lastY = event.localY;
		}
		
		public function mouseMoveHandler(event:MouseEvent):void
		{
			if(dragging)
			{
				this.x += (event.localX - lastX);
				this.y += (event.localY - lastY);				
			}
		}
		
		public function mouseUpHandler(event:MouseEvent):void
		{
			dragging = false;
		}
		
		public function updateInfoWindow():void
		{
			infoWindow = new Sprite();
			var titleView:TextField = new TextField();
			titleView.text = this.instance.getObjectName();
			infoWindow.addChild(titleView);
			var codeView:TextField = new TextField();
			codeView.text = "QR Code: " + this.instance.getInstanceID().toString();
			codeView.y = titleView.y + titleView.textHeight + 3;
			infoWindow.addChild(codeView);
			this.marker.updateInfoWindow(this.infoWindow);
		}
		
	}
}