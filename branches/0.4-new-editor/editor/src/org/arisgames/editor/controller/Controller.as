package org.arisgames.editor.controller
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.core.Container;
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	import org.arisgames.editor.model.Choice;
	import org.arisgames.editor.model.GameObjectReference;
	import org.arisgames.editor.model.Generator;
	import org.arisgames.editor.model.Model;
	import org.arisgames.editor.model.PlayerModification;
	import org.arisgames.editor.model.Requirement;
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
		
		public function onChoicesDataGridDragDrop(event:DragEvent):void
		{
			if(event.dragInitiator is IObjectNavigator)
			{
				currentModel.addChoice(event.dragSource.dataForFormat("treeItems")[0] as GameObjectReference);
			}
		}
		
		public function onChoicesDataGridDragEnter(event:DragEvent):void
		{
			generalizedDragEnterHandler(event, true, [GameObjectReference.PAGE]);
		}
		
		public function onCopyGameButtonClick(event:MouseEvent):void
		{
			currentModel.copyGame(currentView.getSelectedGame());
		}
		
		public function onDeleteGameButtonClick(event:Event):void
		{
			currentModel.deleteGame(currentView.getSelectedGame());
		}
		
		public function onDestroyableCheckBoxChange(event:Event):void
		{
			currentModel.updateDestroyable(currentView.getDestroyable());
		}
		
		public function onDiscardCanvasDragDrop(event:DragEvent):void
		{
			if(event.dragInitiator is IObjectNavigator)
			{
				currentModel.deleteGameObject(event.dragSource.dataForFormat("treeItems")[0] as GameObjectReference);				
			}
			else
			{
				var obj:Object = event.dragSource.dataForFormat("items")[0];
				if(obj is Choice)
				{
					currentModel.removeChoice(obj as Choice);
				}
				else if(obj is Requirement)
				{
					currentModel.removeRequirement(obj as Requirement);
				}
				else if(obj is PlayerModification)
				{
					currentModel.removePlayerModification(obj as PlayerModification);
				}
			}
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
			else if(event.dragSource.hasFormat("items"))
			{
				var obj:Object = event.dragSource.dataForFormat("items")[0];
				if(obj is Choice || obj is Requirement)
				{
					DragManager.acceptDragDrop(event.target as UIComponent)
					DragManager.showFeedback(DragManager.MOVE);
				}
			}
			else
			{
				Alert.show("data formats are: " + event.dragSource.formats[0].toString());
			}
		}
		
		public function onDroppableCheckBoxChange(event:Event):void
		{
			currentModel.updateDroppable(currentView.getDroppable());
		}
		
		public function onEditGameButtonClick(event:Event):void
		{
			currentModel.editGame(currentView.getSelectedGame());	
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
		
		public function onMapContainerDragDrop(event:DragEvent):void
		{
			
		}
		
		public function onMapContainerDragEnter(event:DragEvent):void
		{
			generalizedDragEnterHandler(event, false, [GameObjectReference.CHARACTER, GameObjectReference.ITEM, GameObjectReference.PAGE]);
		}
		
		public function onModificationsDataGridDragDrop(event:DragEvent):void
		{
			currentModel.addModification(event.dragSource.dataForFormat("treeItems")[0] as GameObjectReference);			
		}
		
		public function onModificationsDataGridDragEnter(event:DragEvent):void
		{
			generalizedDragEnterHandler(event, false, [GameObjectReference.ITEM]);
		}
		
		public function onNewGameButtonClick(event:Event):void
		{
			currentModel.createGame();
		}
		
		public function onObjectivesDataGridDragDrop(event:DragEvent):void
		{
			currentModel.addObjective(event.dragSource.dataForFormat("treeItems")[0] as GameObjectReference);
		}
		
		public function onObjectivesDataGridDragEnter(event:DragEvent):void
		{
			generalizedDragEnterHandler(event, false, [GameObjectReference.ITEM, GameObjectReference.PAGE]);
		}
		
		public function onObjectNavigatorClick(event:Event):void
		{
			var selection:Object = currentView.getSelectedGameObject();
			if(selection is GameObjectReference)
			{
				if((selection as GameObjectReference).isMedia())
				{
					//this space reserved for any desired behavior when clicking on a media file
				}
				else
				{
					currentModel.setCurrentGameObject(selection as GameObjectReference);					
				}
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
			generalizedDragEnterHandler(event, true, [GameObjectReference.CHARACTER, GameObjectReference.ITEM, GameObjectReference.PAGE]);
		}
		
		public function onQRCodeContainerDragDrop(event:DragEvent):void
		{
			
		}
		
		public function onRequirementsDataGridDragDrop(event:DragEvent):void
		{
			currentModel.addRequirement(event.dragSource.dataForFormat("treeItems")[0] as GameObjectReference);
		}
		
		public function onRequirementsDataGridDragEnter(event:DragEvent):void
		{
			generalizedDragEnterHandler(event, false, [GameObjectReference.ITEM, GameObjectReference.PAGE]);
		}
		
		public function onSubmitRegistrationButtonClick(event:Event):void
		{
			if(currentView.passwordsMatch())
			{
				currentModel.registerNewUser(currentView.getUsername(),
											 currentView.getPassword(),
											 currentView.getEmail(),
											 currentView.getComments()
											 );
			}
			else
			{
				Alert.show("Passwords do not match.  Please try again.");
			}
		}
		
		///////////////////////
		// Private Functions //
		///////////////////////
		
		private function generalizedDragEnterHandler(event:DragEvent, allowInternalDrag:Boolean, allowedTypes:Array):void
		{
			if(event.dragInitiator is IObjectNavigator)
			{
				var ref:GameObjectReference = event.dragSource.dataForFormat("treeItems")[0] as GameObjectReference;
				if(ref != null && allowedTypes.indexOf(ref.getType()) >= 0)
				{
					DragManager.acceptDragDrop(event.target as UIComponent);
					DragManager.showFeedback(DragManager.COPY);					
				}
			}
			else if(allowInternalDrag && event.target == event.dragInitiator)
			{
				DragManager.acceptDragDrop(event.target as UIComponent);
				DragManager.showFeedback(DragManager.MOVE);
			}
		}
				
	}
}