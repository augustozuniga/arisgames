package org.arisgames.editor.model
{
	import flash.events.Event;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	
	public class MediaUploader
	{
		private static var fileTypes:String = "";
		private static var windowsExtensions:String = "";
		
		private var currentModel:Model;
		private var fileRef:FileReference;
		
		public function MediaUploader(model:Model):void
		{
			this.currentModel = model;
			this.fileRef = new FileReference();
			fileRef.addEventListener(Event.SELECT, selectHandler);
			fileRef.browse(new Array(new FileFilter(fileTypes, windowsExtensions)));
		}
		
		public static function addExtensions(newExtensions:Array):void
		{
//			fileTypes += ;
//			windowsExtensions += ;
		}
		
		public function selectHandler(event:Event):void
		{
//			currentModel.uploadMedia(fileRef);
			fileRef.removeEventListener(Event.SELECT, selectHandler);
		}

	}
}