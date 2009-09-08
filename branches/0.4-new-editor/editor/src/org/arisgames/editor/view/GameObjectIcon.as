package org.arisgames.editor.view
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	
	import mx.controls.Alert;
	
	import org.arisgames.editor.model.GameObjectReference;

	public class GameObjectIcon extends Sprite
	{
		public static const CHARACTER_ICON_URL:String = "character.png";
		public static const CHARACTER_XOFFSET:Number = 2;
		public static const ITEM_ICON_URL:String = "item2.png";
		public static const ITEM_XOFFSET:Number = 0;
		public static const PAGE_ICON_URL:String = "page2.png";
		public static const PAGE_XOFFSET:Number = 0;
		public static const QUEST_ICON_URL:String = "quest.png";
		public static const QUEST_XOFFSET:Number = 0;
		public static const RADIUS:Number = 12;
		public static const YOFFSET:Number = 2;

		public static const ERROR_THRESHHOLD:int = 3;
		
		private static var errorCount:int = 0;
		
		private var loader:Loader;
		private var url:String;
		private var xOffset:Number;

		public function GameObjectIcon(objectType:String)
		{
			loader = new Loader();
			url = "assets/editor icons/";
			if(objectType == GameObjectReference.CHARACTER)
			{
				url += CHARACTER_ICON_URL;
				xOffset = CHARACTER_XOFFSET;
			}
			else if(objectType == GameObjectReference.ITEM)
			{
				url += ITEM_ICON_URL;
				xOffset = ITEM_XOFFSET;
			}
			else if(objectType == GameObjectReference.PAGE)
			{
				url += PAGE_ICON_URL;
				xOffset = PAGE_XOFFSET;
			}
			else if(objectType == GameObjectReference.QUEST)
			{
				url += QUEST_ICON_URL;
				xOffset = QUEST_XOFFSET;
			}
			else
			{
				Alert.show("Error in GameObjectIcon constructor: unknown object type");
			}
			loader.load(new URLRequest(url));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, drawImage);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);		
		}
		
		private function drawImage(event:Event):void
		{
			var myBitmap:BitmapData = new BitmapData(loader.width, loader.height, false);
			var transform:Matrix = new Matrix();
			transform.tx = xOffset - RADIUS;
			transform.ty = YOFFSET - RADIUS;
			myBitmap.draw(loader);
			graphics.lineStyle(1, 0x000000);
			graphics.beginBitmapFill(myBitmap, transform, false, false);
			graphics.drawCircle(0, 0, RADIUS);
			graphics.endFill();
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void
		{
			if(errorCount < ERROR_THRESHHOLD)
			{
				errorCount++;
				var msg:String = "Unable to load image: " + url;
				if(errorCount == ERROR_THRESHHOLD)
				{
					msg += "  Further messages of this type will not be shown.";
				}
				Alert.show(msg);
			}
		}
		
	}
}