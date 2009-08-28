package org.arisgames.editor.controller
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	import org.arisgames.editor.model.Model;
	import org.arisgames.editor.view.IObjectNavigator;
	import org.arisgames.editor.view.View;
	
	[Bindable]
	public class Controller
	{
		private var currentModel:Model;
		private var currentView:View;
		
		public function Controller(newModel:Model, newView:View):void
		{
			currentModel = newModel;
			currentView = newView;
		}
		
		////////////////////
		// Event Handlers //
		////////////////////
		
		public function onDestroyableCheckBoxChange(event:Event):void
		{
			
		}
		
		public function onDiscardCanvasDragEnter(event:DragEvent):void
		{
			if(event.dragInitiator is IObjectNavigator)
			{
				DragManager.acceptDragDrop(event.target as UIComponent);
				DragManager.showFeedback(DragManager.MOVE);
			}
		}
		
		public function onDiscardCanvasDragDrop(event:DragEvent):void
		{
			
		}
		
		public function onDroppableCheckBoxChange(event:Event):void
		{
			
		}
		
		public function onEditGameButtonClick(event:Event):void
		{
			currentModel.editGame(currentView.getSelectedGame());	
		}
		
		public function onGameNameTextInputFocusOut(event:Event):void
		{
			currentModel.updateCurrentGameName(currentView.getGameName());
		}
		
		public function onGameObjectDescriptionTextAreaFocusOut(event:FocusEvent):void
		{
			currentModel.updateGameObjectDescription(currentView.getObjectDescription());
		}
		
		public function onGameObjectNameTextInputChange(event:Event):void
		{
			currentModel.updateGameObjectName(currentView.getObjectName());
		}
		
		public function onLoginButtonClick(event:Event):void
		{
			currentModel.loginUser(currentView.getUsername(), currentView.getPassword());	
		}
		
		public function onMainMenuButtonClick(event:Event):void
		{
			currentModel.closeGame();
		}
		
		public function onMapContainerDragEnter(event:DragEvent):void
		{
			generalizedDragEnterHandler(event, false);
		}
		
		public function onMapContainerDragDrop(event:DragEvent):void
		{
			
		}
		
		public function onNewGameButtonClick(event:Event):void
		{
			currentModel.createGame();
		}
		
		public function onObjectNavigatorClick(event:Event):void
		{
			currentModel.setCurrentGameObject(currentView.getSelectedGameObject());
		}
		
		public function onPasswordEnter(event:Event):void
		{
			currentModel.loginUser(currentView.getUsername(), currentView.getPassword());
		}
		
		public function onQRCodeContainerDragEnter(event:DragEvent):void
		{
			generalizedDragEnterHandler(event, true);
		}
		
		public function onQRCodeContainerDragDrop(event:DragEvent):void
		{
			
		}
		
		public function onRegisterButtonClick(event:Event):void
		{
			
		}
		
		///////////////////////
		// Private Functions //
		///////////////////////
		
		private function generalizedDragEnterHandler(event:DragEvent, allowInternalDrag:Boolean):void
		{
			if(event.dragInitiator is IObjectNavigator)
			{
				DragManager.acceptDragDrop(event.target as UIComponent);
				DragManager.showFeedback(DragManager.COPY);
			}
			else if(allowInternalDrag && event.target == event.dragInitiator)
			{
				DragManager.acceptDragDrop(event.target as UIComponent);
				DragManager.showFeedback(DragManager.MOVE);
			}
		}
		
	}
}