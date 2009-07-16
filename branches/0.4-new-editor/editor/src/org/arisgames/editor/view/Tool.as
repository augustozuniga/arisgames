package org.arisgames.editor.view
{
	import flash.events.MouseEvent;
	
	import mx.core.DragSource;
	import mx.core.IFlexDisplayObject;
	import mx.core.UIComponent;
	import mx.managers.DragManager;
	
	// this class is intended to be ABSTRACT
	public class Tool extends UIComponent
	{
		protected var isGenerator:Boolean;
		protected var isInitialized:Boolean;
		
		public function Tool():void
		{
			this.isInitialized = false;
			this.isGenerator = false;
		}
		
		public function initializeTool(isGen:Boolean = false, draggable:Boolean = true):void
		{
			if(!isInitialized)
			{
				if(isGen)
				{
					this.isGenerator = true;
				}
				if(draggable)
				{
					this.addEventListener(MouseEvent.MOUSE_DOWN, startDragging);
				}
				this.isInitialized = true;
			}
		}
		
		protected function startDragging(e:MouseEvent):void
		{
			var dragInitiator:Tool = this;
			if(this.isGenerator)
			{
				dragInitiator = this.generateCopy();
			}
			var dragSource:DragSource = new DragSource();
			dragSource.addData(dragInitiator, 'Tool');
			var dragProxy:Tool = dragInitiator;
			DragManager.doDrag(this, dragSource, e, dragProxy, this.x - e.localX, this.y - e.localY); 
		}
				
		//this method should be overridden in derived class to generate derived class as copy
		public function generateCopy(addCopy:Boolean = true, draggable:Boolean = true):Tool
		{
			var myCopy:Tool = new Tool();
			myCopy.initializeTool(false, draggable);
			if(addCopy)
			{
				this.parent.addChild(myCopy);
			}
			return myCopy;
		}		
	}
}