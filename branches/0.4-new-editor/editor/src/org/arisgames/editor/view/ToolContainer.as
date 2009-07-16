package org.arisgames.editor.view
{
	import flash.display.Sprite;
	
	public class ToolContainer extends Sprite
	{
		private var tool:Tool;
		
		public function ToolContainer(tool:Tool):void
		{
			this.tool = tool;
			this.tool.x = 25;
			this.tool.y = 45;
			this.addChild(tool);
		}
	}
}