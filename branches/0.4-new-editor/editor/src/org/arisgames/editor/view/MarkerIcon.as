package org.arisgames.editor.view
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.arisgames.editor.controller.Controller;
	import org.arisgames.editor.model.GameObjectInstance;

	public class MarkerIcon extends Sprite
	{
		private static const HALO_RADIUS:Number = GameObjectIcon.RADIUS + 3;
		private static const ICON_YOFFSET:Number = -25;
		private static const PIN_LENGTH:Number = -(ICON_YOFFSET + GameObjectIcon.RADIUS);
		private static const PIN_WIDTH:Number = 1;
		private static const SHADOW_ALPHA:Number = 0.25;
		
		private var currentController:Controller;
		private var halo:Sprite;
		private var instance:GameObjectInstance;
		private var objectIcon:GameObjectIcon;
		
		public function MarkerIcon(instance:GameObjectInstance, currentController:Controller)
		{
			this.instance = instance;
			this.currentController = currentController;
			this.objectIcon = new GameObjectIcon(instance.getObjectType());
			this.objectIcon.y = ICON_YOFFSET;
			this.halo = new Sprite();
			halo.graphics.beginFill(0xFFFF00, 0.5);
			halo.graphics.drawCircle(0, ICON_YOFFSET, HALO_RADIUS);
			halo.graphics.endFill();
			halo.visible = false;
			drawShadow();
			graphics.beginFill(0x000000);
			graphics.drawRect(-0.5*PIN_WIDTH, -PIN_LENGTH, PIN_WIDTH, PIN_LENGTH);
			graphics.endFill();
			this.addChild(halo);
			this.addChild(this.objectIcon);
			this.addEventListener(MouseEvent.CLICK, currentController.showInfoWindow);
		}
		
		private function drawShadow():void
		{
			for(var i:int = 1; i < 4; i++)
			{
				graphics.lineStyle(1 + i, 0x000000, SHADOW_ALPHA);
				graphics.moveTo(0,0);
				graphics.lineTo(2.3, -4.5);
				graphics.lineStyle(0, 0, 0);
				graphics.beginFill(0x000000, SHADOW_ALPHA);
				graphics.drawCircle(7.5, -13, 7+i);
				graphics.endFill();
			}
		}
		
		private function getInstance():GameObjectInstance
		{
			return instance;
		}
		
		private function hideHalo():void
		{
			halo.visible = false;
		}
		
		private function isHaloVisible():Boolean
		{
			return halo.visible;
		}
		
		private function showHalo():void
		{
			halo.visible = true;
		}
		
	}
}