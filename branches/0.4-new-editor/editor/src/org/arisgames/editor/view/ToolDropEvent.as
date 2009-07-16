package org.arisgames.editor.view
{
	import flash.events.Event
	
	public class ToolDropEvent extends Event
	{
		public static const TOOL_DROP:String = "ToolDrop";
		public static const TOOL:String = "Tool";
		public static const EVENT_TOOL:String = "EventTool";
		public static const ITEM_TOOL:String = "ItemTool";
		public static const VIRTUAL_PERSON_TOOL:String = "VirtualPersonTool";
		
		private var toolType:String;
		private var xPos:int;
		private var yPos:int;
		
		public function ToolDropEvent(toolType:String, xPos:Number, yPos:Number):void
		{
			super(TOOL_DROP, true, false);
			this.toolType = toolType;
			this.xPos = xPos;
			this.yPos = yPos;
		}
		
		public function getToolType():String
		{
			return this.toolType;
		}
		
		public function getXPos():int
		{
			return this.xPos;
		}
		
		public function getYPos():int
		{
			return this.yPos;
		}
	}
}