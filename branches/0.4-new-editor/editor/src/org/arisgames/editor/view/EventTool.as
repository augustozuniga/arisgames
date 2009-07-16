package org.arisgames.editor.view
{
	public class EventTool extends Tool
	{
		
		public static const EVENT_COLOR:uint = 0x6666FF;
		
		public function EventTool():void
		{
			super();
			//draw pin
			graphics.lineStyle(1, 0x000000);
			graphics.beginFill(EVENT_COLOR);
			graphics.drawCircle(0, -25, 10);
			graphics.drawRect(-0.5, -15, 1, 10);
			graphics.endFill();
			//draw event symbol inside pin head
			graphics.moveTo(-4.25, -21);
			graphics.lineTo(3.75, -29);
			graphics.moveTo(3.75, -21);
			graphics.lineTo(-4.25, -29);
			graphics.moveTo(-6.25, -25);
			graphics.lineTo(5.75, -25);
			graphics.moveTo(-0.25, -19);
			graphics.lineTo(-0.25, -31);
		}
				
		public override function generateCopy(addCopy:Boolean = true, draggable:Boolean = true):Tool
		{
			var myCopy:Tool = new EventTool();
			myCopy.initializeTool(false, draggable);
			if(addCopy)
			{
				myCopy.x = this.x;
				myCopy.y = this.y;
				this.parent.addChild(myCopy);
			}
			return myCopy;
		}		

	}
}