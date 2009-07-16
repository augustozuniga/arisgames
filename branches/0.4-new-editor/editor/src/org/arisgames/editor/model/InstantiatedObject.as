package org.arisgames.editor.model
{
	[Bindable]
	public class InstantiatedObject extends GameObject
	{
		private var instances:Array;
		private var currentInstanceIndex:int;
		
		public function InstantiatedObject(id:int, type:String):void
		{
			super(id, type);
			this.instances = new Array();
			this.currentInstanceIndex = -1;
		}

		public function addInstance(instanceProperties:InstanceProperties):void
		{
			this.instances.push(instanceProperties);
		}
		
		public function removeInstance(instanceIndex:int):void
		{
			this.instances.splice(instanceIndex, 1);
		}
		
		public function getInstanceByIndex(instanceIndex:int):InstanceProperties
		{
			return instances[instanceIndex];
		}
		
		public function getNextInstance():InstanceProperties
		{
			this.currentInstanceIndex++;
			if(this.currentInstanceIndex >= getNumInstances())
			{
				this.currentInstanceIndex = 0;
			}
			return getInstanceByIndex(currentInstanceIndex);
		}
		
		public function getPreviousInstance():InstanceProperties
		{
			this.currentInstanceIndex--;
			if(this.currentInstanceIndex < 0)
			{
				this.currentInstanceIndex = getNumInstances() - 1;
			}
			return getInstanceByIndex(currentInstanceIndex);
		}
		
		public function getNumInstances():int
		{
			return instances.length;
		}
		

	}
}