package nl.mpi.lexus.view
{
	import flash.text.Font;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.controls.ComboBox;
	import mx.core.ClassFactory;
	import mx.events.DropdownEvent;
	import mx.events.FlexEvent;
	
	public class FontStyleList extends ComboBox
	{	
		
		private var fontList:ArrayCollection;
		
		private var _selectedFontName:String;
		
		public function set selectedFontName(value:String):void {    
			if (value != null)  {
				_selectedFontName = value;
			}
		}
		
		public function get selectedFontName():String {
			return _selectedFontName;
		}
		
		public function FontStyleList()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, listCreated);
			
		}
		private function listCreated(e:FlexEvent):void{
			fontList = new ArrayCollection(Font.enumerateFonts(true));
			labelField = "fontName";
			setStyle("fontSize",15);
			var fontSort:Sort = new Sort();
			fontSort.fields = [new SortField("fontName")];
			fontList.sort = fontSort;
			fontList.refresh();
			dataProvider = fontList;
			itemRenderer = new ClassFactory(FontStyleRenderer);
			dropdown.variableRowHeight = true;
			for (var i:int = 0; i < fontList.length ; i++) {
				var font:Font = Font(fontList.getItemAt(i));
				if (font.fontName == _selectedFontName) {
					this.selectedItem = font;
					break;
				}
			}
		}
	}
}
