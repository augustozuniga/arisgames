package org.arisgames.editor.view
{
	import flash.display.Sprite;
	
	public class MapContainer extends Sprite
	{
		import flash.geom.Point;
		import com.google.maps.LatLng;
		import com.google.maps.Map;
		import com.google.maps.MapEvent;
		import com.google.maps.MapType;
		import com.google.maps.MapOptions;
		import com.google.maps.controls.PositionControl;
		import com.google.maps.controls.ZoomControl;
		import com.google.maps.controls.ZoomControlOptions;
		import com.google.maps.controls.MapTypeControl;
		import com.google.maps.controls.ScaleControl;
		import com.google.maps.overlays.Marker;
		import com.google.maps.overlays.MarkerOptions;		
		
		public static const TOOLBIN_WIDTH:Number = 50;
		public static const NUM_TOOLBINS:int = 3;
		public static const TOOLBAR_HEIGHT:Number = TOOLBIN_WIDTH * NUM_TOOLBINS;
		public static const DEFAULT_HEIGHT:Number = 400;
		public static const BORDER_WIDTH:Number = 4;
		public static const BORDER_COLOR:Number = 0x000000;
		
		private var map:Map;
		private var itemGenerator:ItemTool;
		private var personGenerator:VirtualPersonTool;
		private var eventGenerator:EventTool;
		
		public function MapContainer(initialHeight:Number = DEFAULT_HEIGHT):void
		{
			map = new Map();
			map.key = "ABQIAAAAaBINj42Tz4K8ZaoZWWSnWRT2yXp_ZAY8_ufC3CFXhHIE1NvwkxQkcVoUCrdum-UscUMoKinDrDjThQ";
			map.addEventListener(MapEvent.MAP_PREINITIALIZE, onMapPreinitialize);
			map.addEventListener(MapEvent.MAP_READY, onMapReady);
			map.x = 0.5 * BORDER_WIDTH;
			map.y = 0.5 * BORDER_WIDTH;
			this.resizeMap(initialHeight);
			this.addChild(map);
			
			itemGenerator = new ItemTool(true);
			itemGenerator.x = -0.5 * TOOLBIN_WIDTH;
			itemGenerator.y = TOOLBIN_WIDTH - 0.5 * (TOOLBIN_WIDTH - itemGenerator.height);
			this.addChild(itemGenerator);
			
			personGenerator = new VirtualPersonTool(true);
			personGenerator.x = -0.5 * TOOLBIN_WIDTH;
			personGenerator.y = 2 * TOOLBIN_WIDTH - 0.5 * (TOOLBIN_WIDTH - itemGenerator.height);
			this.addChild(personGenerator);
			
			eventGenerator = new EventTool(true);
			eventGenerator.x = -0.5 * TOOLBIN_WIDTH;
			eventGenerator.y = 3 * TOOLBIN_WIDTH - 0.5 * (TOOLBIN_WIDTH - itemGenerator.height);
			this.addChild(eventGenerator);
			
			this.addEventListener(ToolDropEvent.TOOL_DROP, onToolDrop);
		}
		
		private function drawBoxes(mapHeight:Number):void
		{
			graphics.clear();
			graphics.lineStyle(BORDER_WIDTH, BORDER_COLOR);
			graphics.drawRect(0, 0, mapHeight, mapHeight);
			for(var i:int = 0; i < NUM_TOOLBINS; i++)
			{
				graphics.drawRect(-TOOLBIN_WIDTH, i * TOOLBIN_WIDTH, TOOLBIN_WIDTH, TOOLBIN_WIDTH);
			}
		}
		
		internal function resizeMap(newHeight:Number):void
		{
			drawBoxes(newHeight);
			map.setSize(new Point(newHeight - BORDER_WIDTH, newHeight - BORDER_WIDTH));
		}

		
		private function onMapPreinitialize(event:MapEvent):void
		{
			map.setInitOptions
			(
				new MapOptions
				({
					center: new LatLng(43.0746561,-89.384422),
					zoom: 14,
					mapType: MapType.NORMAL_MAP_TYPE
				 })
			);
		}
		
		private function onMapReady(event:MapEvent):void
		{
			var zco:ZoomControlOptions = new ZoomControlOptions();
			zco.hasScrollTrack = false;
			map.addControl(new ZoomControl(zco));
		
			map.addControl(new PositionControl());
			map.addControl(new MapTypeControl());
			map.addControl(new ScaleControl());
		}
		
		private function onToolDrop(evt:ToolDropEvent):void
		{
			var droppedTool:Tool = evt.target as Tool;
			var xFrac:Number = (evt.getXPos() - map.x) / map.width;
			var yFrac:Number = (evt.getYPos() - map.y) / map.height;
			if(   xFrac >= 0 && xFrac <= 1
			   && yFrac >= 0 && yFrac <= 1)
			{
				var northWest:LatLng = map.getLatLngBounds().getNorthWest();
				var southEast:LatLng = map.getLatLngBounds().getSouthEast();
				var markerPos:LatLng = new LatLng(southEast.lat() + (1 - yFrac) * (northWest.lat() - southEast.lat()),
												  northWest.lng() +      xFrac  * (southEast.lng() - northWest.lng()));
				var toolMarker:Marker = new Marker(markerPos, new MarkerOptions({icon: droppedTool.generateCopy(false, false),
																				 draggable: true}));
				map.addOverlay(toolMarker);
			}
			this.removeChild(droppedTool);
		}
	}
}