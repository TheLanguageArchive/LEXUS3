package nl.mpi.lexus.view
{
	import mx.collections.*;
	import mx.controls.treeClasses.*;
	import mx.events.ToolTipEvent;
	import mx.core.IToolTip;
	import mx.core.FlexGlobals;
	import flash.geom.Point;
	import mx.core.IFactory;
	
	public class NodeRenderer extends TreeItemRenderer implements IFactory
	{
		private var application:Object = FlexGlobals.topLevelApplication;
		
		public function NodeRenderer()
		{
			super();
			// listen for the tooltip shown event
			addEventListener(ToolTipEvent.TOOL_TIP_SHOWN, toolTipShown);
		}
		
		// Override the set method for the data property
		// to set the font color and style of each node.        
		override public function set data(value:Object):void {
			super.data = value;
			if (null != data) {
				if(data.@type == 'data category' && data.hasOwnProperty("@id")){
					if((data as XML).attribute("id").toString() == '' ||
						this.application.modules.schema_editor.extractDataCategory(data.@id, this.application.modules.schema_editor.tree.dataProvider[0]) == null){
						setStyle("color", "red");
						setStyle("fontFamily", "Arial");
						setStyle("fontSize", "12");
						setStyle("fontWeight", "normal");
						return;
					}					
				}
				
				if ((data.@type == 'dsl_show' || data.@type == 'data category') && data.@localStyle == 'true') {
					if((data as XML).attribute("color").toString() != "")
						setStyle("color", data.@color);
					else
						setStyle("color", "#000000");
					if((data as XML).attribute("fontFamily").toString() != "")
						setStyle("fontFamily", data.@fontFamily);
					else
						setStyle("fontFamily", "Arial");
					if((data as XML).attribute("fontSize").toString() != "")
						setStyle("fontSize", data.@fontSize);
					else
						setStyle("fontSize", "10");
					if((data as XML).attribute("fontStyle").toString() != "")
						setStyle("fontStyle", data.@fontStyle);
					else
						setStyle("fontStyle", "normal");
					if((data as XML).attribute("fontWeight").toString() != "")
						setStyle("fontWeight", data.@fontWeight);
					else
						setStyle("fontWeight", "normal");
					if((data as XML).attribute("textDecoration").toString() != "")
						setStyle("textDecoration", data.@textDecoration);
					else
						setStyle("textDecoration", "none");
				}
				else {					
					setStyle("color", "#000000");
					setStyle("fontFamily", "Arial");
					setStyle("fontSize", "12");
					setStyle("fontWeight", "normal");

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
				} else if (type == 'dsl_horizontal_line') {
					s = data.@name;
				} else if (type == 'dsl_line_break') {
					s = data.@name;
				} else if (type == 'dsl_show' || type == 'dsl_multiplier') {
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
								
								if (item.hasOwnProperty("@id")) {
									var dc:Object = this.application.modules.schema_editor.extractDataCategory(item.@id, this.application.modules.schema_editor.tree.dataProvider[0]);
									if (dc == null)
										s += "<deleted datacategory!>";
									else
										s += ' <' + dc.name + '> ';
								} else
									s += "<unsaved datacategory!>";
							}
						}
						if (s == '')
							s = data.@name;
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
					if (data.hasOwnProperty("@id")) {
						var element:Object = this.application.modules.schema_editor.extractDataCategory(data.@id, this.application.modules.schema_editor.tree.dataProvider[0]);
						if (element == null)
							s = "deleted datacategory!";
						else
							s = element.name;
					} else
						s = "unsaved datacategory!";
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
				if (data.hasOwnProperty("@dsl_class") && data.hasOwnProperty("@localStyle") && data.@localStyle == false) {
					if (data.@dsl_class != "") {
						s += " [class=" + data.@dsl_class + "]";						
					}
				}
				
				/* Set the label */
				super.label.text = s;
			}
		}
		
		
		//AAM: stuff to position the tooltip not over the highlighted node	
		public function newInstance():* {
			return new NodeRenderer();
		}
		/**
		 * Positions the tooltip to show up below the node.
		 * It will move the tooltip above if it would be outside the tree.
		 */
		private function toolTipShown(event:ToolTipEvent):void {
			var tt:IToolTip = event.toolTip;
			// get the global size of this item renderer instances
			var pt:Point = localToGlobal(new Point());
			// position below this item renderer
			var ty:Number = pt.y + this.height;
			// don't let the toolTip go outside the parent (below)
			var parentLoc:Point = parent.localToGlobal(new Point());
			var bottom:Number = ty + tt.height;
			if (bottom > (parentLoc.y + parent.height)) {
				ty = pt.y - tt.height;    // position above this node
			}
			// position the tooltip
			tt.move(FlexGlobals.topLevelApplication.mouseX, ty);
		}
	}
}
