package org.arisgames.editor.controller
{
	import flash.display.Sprite
	
	public class Controller extends Sprite implements IController
	{
		import org.arisgames.editor.model.IModel;
		
		private var model:IModel;
		
		public function Controller(model:IModel):void
		{
			this.model = model;
		}		
	}
}