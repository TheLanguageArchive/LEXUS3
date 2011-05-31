package nl.mpi.lexus.view
{
	import mx.collections.*;
	import mx.controls.treeClasses.*;
	
	public class NodeRenderer extends TreeItemRenderer
	{
		public function NodeRenderer()
		{
			super();
		}
		
		// Override the set method for the data property
		// to set the font color and style of each node.        
		override public function set data(value:Object):void {
			super.data = value;
			if (null != data) {
				if (data.@type == 'dsl_show' && data.@localStyle == 'true') {
					setStyle("color", data.@color);
					setStyle("fontFamily", data.@fontFamily);
					setStyle("fontSize", "12");
				}
				else {					
					setStyle("color", "#000000");
					setStyle("fontFamily", "Arial");
					setStyle("fontSize", "12");
				}
			}
		}
		
		// Override the updateDisplayList() method 
		// to set the text for each tree node.      
		override protected function updateDisplayList(unscaledWidth:Number, 
													  unscaledHeight:Number):void {
			
			var data:XML = new XML(super.data);
			var name:String = data.localName();
			var type:String = data.@type;
			var value:String = data.@value;
			var listData:Object = TreeListData(super.listData);
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			var s:String = "";
			
			if (data) {
				if (type == 'dsl_text') {
					s = value;
				}
				else if (type == 'dsl_show') {
					var tmp:XMLList = 
						new XMLList(listData.item);
					for (var t:int = 0 ; t < tmp.length() ; t++) {
						var children:XMLList = tmp[t].children();
						for (var i:int = 0 ; i < children.length() ; i++) {
							var item:XML = children[i];
							if (item.@type == 'dsl_text') {
								s += item.@value;
							}
							if (item.@type == 'data category') {
								s += ' <' + item.@name + '> ';
							}
						}
					}
				}
				else if (type == 'dsl_table' ||
						 type == 'dsl_table_row' ||
						 type == 'dsl_table_column' ||
						 type == 'dsl_table_heading' ||
						 type == 'dsl_table_body') {
					s = data.@name;
				}
				else if (type == 'data category' || type == 'container') {
					s = data.@name;
				}
				else if (name == 'structure') {
					s = "view";
				}
				else if (name == 'style') {
					s = name;
				}
				else if (name == 'view') {
					s = name;
				}
				else if (data.hasOwnProperty("@name")) {
					s = data.@name;
				}
				else {
					s = "unknown node";
				}
				
				/* Add the class */
				if (data.hasOwnProperty("@dsl_class")) {
					if (data.@dsl_class != "") {
						s += " [class=" + data.@dsl_class + "]";						
					}
				}
				
				/* Set the label */
				super.label.text = s;
			}
		}
	}
}
