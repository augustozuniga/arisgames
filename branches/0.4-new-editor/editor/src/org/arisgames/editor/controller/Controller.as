package org.arisgames.editor.controller
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	import org.arisgames.editor.model.GameObjectReference;
	import org.arisgames.editor.model.Generator;
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
			currentModel.updateDestroyable(currentView.getDestroyable());
		}
		
		public function onDiscardCanvasDragEnter(event:DragEvent):void
		{
			if(event.dragInitiator is IObjectNavigator)
			{
				if(event.dragSource.dataForFormat("treeItems")[0] is GameObjectReference)
				{
					DragManager.acceptDragDrop(event.target as UIComponent);
					DragManager.showFeedback(DragManager.MOVE);					
				}
			}
		}
		
		public function onDiscardCanvasDragDrop(event:DragEvent):void
		{
			currentModel.deleteGameObject(event.dragSource.dataForFormat("treeItems")[0] as GameObjectReference);
		}
		
		public function onDroppableCheckBoxChange(event:Event):void
		{
			currentModel.updateDroppable(currentView.getDroppable());
		}
		
		public function onEditGameButtonClick(event:Event):void
		{
			currentModel.editGame(currentView.getSelectedGame());	
		}
		
		public function onGameNameTextInputFocusOut(event:Event):void
		{
			currentModel.updateCurrentGameName(currentView.getGameName());
		}
		
		public function onGameObjectCompletedDescriptionTextAreaFocusOut(event:Event):void
		{
			currentModel.updateCompletedDescription(currentView.getCompletedDescription());
		}
		
		public function onGameObjectDescriptionTextAreaFocusOut(event:FocusEvent):void
		{
			currentModel.updateGameObjectDescription(currentView.getObjectDescription());
		}
		
		public function onGameObjectGreetingTextAreaFocusOut(event:FocusEvent):void
		{
			currentModel.updateGreeting(currentView.getGreeting());
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
			var selection:Object = currentView.getSelectedGameObject();
			if(selection is GameObjectReference)
			{
				currentModel.setCurrentGameObject(selection as GameObjectReference);				
			}
			if(selection is Generator)
			{
				currentModel.createNewGameObject(selection as Generator);
			}
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