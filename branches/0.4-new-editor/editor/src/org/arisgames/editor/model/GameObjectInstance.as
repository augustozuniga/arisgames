package org.arisgames.editor.model
{
	public class GameObjectInstance
	{
		private var ref:GameObjectReference;
		
		public function GameObjectInstance(ref:GameObjectReference)
		{
			this.ref = ref;
		}
		
		public function getObjectType():String
		{
			return ref.getType();
		}

	}
}