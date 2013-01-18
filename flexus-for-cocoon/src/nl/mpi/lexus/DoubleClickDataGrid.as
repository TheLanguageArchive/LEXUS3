package nl.mpi.lexus
{
	import mx.controls.DataGrid;
	import flash.events.MouseEvent;
	
	
	/**
	 * This is a DataGrid extension that requires a double-click on its elements,
	 * in order to edit them.
	 * 
	 * Use this if you wish an editable DataGrid but you would like users to 
	 * double-click an element to edit it, instead of the regular single-click on 
	 * selected or even non-selected element.
	 * 
	 * @author André Moreira
	 * 
	 */	
	
	
	
	public class DoubleClickDataGrid extends DataGrid {
		public function DoubleClickDataGrid() {
			super();
			doubleClickEnabled = true;
		}
		override protected function mouseDoubleClickHandler(event:MouseEvent):void {
			super.mouseDoubleClickHandler(event);
			// simulate a click (just calling the mouseUpHandler wont work)
			super.mouseDownHandler(event);
			super.mouseUpHandler(event);
		}
		override protected function mouseUpHandler(event:MouseEvent):void {
			// prevent edits on normal mouse-up
			var saved:Boolean = editable;
			editable = false;
			super.mouseUpHandler(event);
			editable = saved;
		}
	}
}