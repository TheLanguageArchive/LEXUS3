package nl.mpi.lexus.view
{
	import flash.text.Font;
	
	import mx.controls.Label;
	import mx.events.FlexEvent;
	
	public class FontStyleRenderer extends Label
	{
		public function FontStyleRenderer()
		{
			super();
		}
		override public function set data(value:Object):void{
				super.data = value;
				if(value is Font)
					setStyle("fontFamily",value.fontName);
				else
					setStyle("fontFamily","Verdana");
				text = value.fontName;
				dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
		}
	}
}
