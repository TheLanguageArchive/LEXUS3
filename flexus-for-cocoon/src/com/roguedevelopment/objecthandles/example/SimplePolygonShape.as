package com.roguedevelopment.objecthandles.example
{
	import __AS3__.vec.Vector;
	
	import mx.core.UIComponent;
	import mx.events.PropertyChangeEvent;

	
	/** 
	 * This is an example and not part of the core ObjectHandles library. 
	 **/

	public class SimplePolygonShape extends SimpleGenericShape
	{
		protected var _model:SimpleDataModel;
		
	    private var commands:Vector.<int> = new Vector.<int>();			
	    private var coords:Vector.<Number> = new Vector.<Number>();
	    private var ratios:Vector.<Number> = new Vector.<Number>();
		
		public function SimplePolygonShape(commands:Vector.<int>, coords:Vector.<Number>)
		{
			super();
			this.commands = commands;
			this.coords = coords;
		}

		public function set model( model:SimpleDataModel ) : void
		{			
			if( _model )
			{
				_model.removeEventListener( PropertyChangeEvent.PROPERTY_CHANGE, onModelChange );
			}			
			_model = model;
			redraw();
			x = model.x;
			y = model.y;			
//			x = model.x - PANEL_LEFT_BORDER;
//			y = model.y - PANEL_UPPER_BORDER;
			model.addEventListener( PropertyChangeEvent.PROPERTY_CHANGE, onModelChange );
//			trace("model:", model.x, model.y, model.width, model.height);
			
			var len:int = coords.length;
			for (var c:int = 0; c < len; c++){
				if (c % 2 == 0){
					ratios.push(coords[c] / model.width);
				}
				else{
					ratios.push(coords[c] / model.height);
				}
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			redraw();
		}
		
		protected function onModelChange( event:PropertyChangeEvent):void
		{
			switch( event.property )
			{
				case "x": x = event.newValue as Number; break;
				case "y": y = event.newValue as Number; break;				
//				case "x": x = event.newValue as Number; x-= PANEL_LEFT_BORDER; break;
//				case "y": y = event.newValue as Number; y-= PANEL_UPPER_BORDER; break;
				case "rotation": rotation = event.newValue as Number; break;
				case "width":  
				case "height": break;
				default: return;
			}
//			trace(x, y, rotation, _model.width, _model.height);
			redraw();
		}
		
		public function getHandleObjectData():Object{
			
			var coords:Vector.<Number> = new Vector.<Number>();
			var len:int = ratios.length;
			
			for (var r:int = 0; r < len; r++){
				// x
				if (r % 2 == 0){
					coords.push(ratios[r] * _model.width);
				}
				
				// y
				else{
					coords.push(ratios[r] * _model.height);
				}
			}			
			
			return ({	xPos:x, yPos:y, rotation:rotation, 
						width:_model.width, height:_model.height,
						commands:this.commands, coords:coords});
		}
		
		protected function redraw() : void
		{
			if(!_model){return;}
			graphics.clear();
			graphics.lineStyle(1,0);
			graphics.beginFill(0x555555,0.6);

			var coords:Vector.<Number> = new Vector.<Number>();
			var len:int = ratios.length;
			
			for (var r:int = 0; r < len; r++){
				// x
				if (r % 2 == 0){
					coords.push(ratios[r] * _model.width);
					//coords.push(ratios[r] * _model.width + PANEL_LEFT_BORDER);
				}
				
				// y
				else{
					coords.push(ratios[r] * _model.height);
//					coords.push(ratios[r] * _model.height + PANEL_UPPER_BORDER);
				}
			}

//			graphics.drawPath(this.commands, this.coords);
			graphics.drawPath(this.commands, coords);
			graphics.endFill();
//			trace(x, y, rotation, _model.width, _model.height);
		}
		
	}
}