package org.arisgames.editor.view
{
	public class ItemTool extends Tool
	{
		public static const ITEM_COLOR:uint = 0x00FF00;
		
		public function ItemTool():void
		{
			super();
			//draw pin
			graphics.lineStyle(1, 0x000000);
			graphics.beginFill(ITEM_COLOR);
			graphics.drawCircle(0, -25, 10);
			graphics.drawRect(-0.5, -15, 1, 10);
			graphics.endFill();
			//draw item symbol inside pin head
			graphics.moveTo(-4, -21);
			graphics.lineTo(4, -29);
			graphics.moveTo(6, -25);
			graphics.curveTo(5, -30, 0, -31);
		}
		
		public override function generateCopy(addCopy:Boolean = true, draggable:Boolean = true):Tool
		{
			var myCopy:Tool = new ItemTool();
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