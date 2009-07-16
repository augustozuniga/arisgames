package org.arisgames.editor.view
{
	public class VirtualPersonTool extends Tool
	{
		public static const VIRTUAL_PERSON_COLOR:uint = 0xFF6666;
		
		public function VirtualPersonTool():void
		{
			super();
			//draw pin
			graphics.lineStyle(1, 0x000000);
			graphics.beginFill(VIRTUAL_PERSON_COLOR);
			graphics.drawCircle(0, -25, 10);
			graphics.drawRect(-0.5, -15, 1, 10);
			graphics.endFill();
			//draw person symbol inside pin head
			graphics.drawEllipse(-4, -28, 2, 3);
			graphics.drawEllipse(2, -28, 2, 3);
			graphics.moveTo(-4, -21);
			graphics.curveTo(0, -18, 4, -21);
		}
		
		public override function generateCopy(addCopy:Boolean = true, draggable:Boolean = true):Tool
		{
			var myCopy:Tool = new VirtualPersonTool();
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