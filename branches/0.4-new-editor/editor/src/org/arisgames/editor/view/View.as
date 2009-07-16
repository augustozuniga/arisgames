package org.arisgames.editor.view
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.Stage;
	
	import org.arisgames.editor.controller.IController;
	import org.arisgames.editor.model.IModel;
	
	public class View extends Sprite
	{
		public static const SWF_BORDER:Number = 10;
		
		private var model:IModel;
		private var controller:IController;
		private var mapContainer:MapContainer;
		private var theStage:Stage;
		
		public function View(model:IModel, controller:IController):void
		{
			this.model = model;
			this.controller = controller;
			this.theStage = null;
			
			mapContainer = new MapContainer();
			mapContainer.x = SWF_BORDER + MapContainer.TOOLBIN_WIDTH;
			mapContainer.y = SWF_BORDER;
			this.addChild(mapContainer);
		}
		
		public function setStage(theStage:Stage):void
		{
			this.theStage = theStage;
			theStage.addEventListener(Event.RESIZE, resizeView);
			this.resizeView(new Event(Event.RESIZE));
		}
				
		private function resizeView(e:Event):void
		{
			var swfWidth:int = theStage.stageWidth;
			var swfHeight:int = theStage.stageHeight;
			var mapHeight:Number = Math.min(swfWidth - MapContainer.TOOLBIN_WIDTH - 2 * SWF_BORDER,
											swfHeight - 2 * SWF_BORDER);
			
			mapContainer.resizeMap(mapHeight);
		}
	}
}