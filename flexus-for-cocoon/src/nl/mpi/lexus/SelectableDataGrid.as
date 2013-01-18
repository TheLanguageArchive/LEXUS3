package nl.mpi.lexus
{
	import mx.controls.DataGrid;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.events.ListEvent;
	import flash.events.MouseEvent;
	
	/**
	 * This is a DataGrid extension which requires that a element must be selected first,
	 * in orther for a single-click to triger its edition.
	 * 
	 * Use this if you whish an editable DataGrid but you would like users to select the element
	 * first, so that they can edit it. Instead of the regular single-click on selected or even 
	 * non-selected element.
	 * 
	 * @author André Moreira
	 * 
	 */	



	public class SelectableDataGrid extends DataGrid
	{
		private var _selectedRow:int = -1;
		private var _clickCount:uint;
		
		public function SelectableDataGrid()
		{
			super();
		}
		
		
		
		override protected function mouseUpHandler( event:MouseEvent ):void
		{
			editable = (_clickCount == 2);
			
			super.mouseUpHandler( event );
		}
		
		override protected function selectItem( item:IListItemRenderer, shiftKey:Boolean, ctrlKey:Boolean, transition:Boolean=true ):Boolean
		{
			var returnValue:Boolean = super.selectItem( item, shiftKey, ctrlKey, transition );
			
			if (selectedIndex == _selectedRow)
			{
				_clickCount = 2;
			}
			else
			{
				_selectedRow = selectedIndex;
				_clickCount = 1;
			}
			
			return returnValue;
		}
		
		
	}
}