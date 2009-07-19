package org.arisgames.editor
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.Stage;
	
	public class Main extends Sprite
	{
		//import interfaces
		import org.arisgames.editor.model.IModel;
		import org.arisgames.editor.controller.IController;
		//import specific classes
		import org.arisgames.editor.model.Model;
		import org.arisgames.editor.controller.Controller;
		import org.arisgames.editor.view.View;

		private var model:IModel;
		private var controller:IController;
		private var view:View;
		
		public function Main()
		{
			model = new Model();
			controller = new Controller(model);
			view = new View(model, controller);
			addChild(view);
		}
		
		public function setStage(theStage:Stage):void
		{
			view.setStage(theStage);
		}
	}
}