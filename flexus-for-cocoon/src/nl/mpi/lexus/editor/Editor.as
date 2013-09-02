package nl.mpi.lexus.editor
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Grid;
	import mx.containers.GridItem;
	import mx.containers.GridRow;
	import mx.containers.Panel;
	import mx.controls.ComboBox;
	import mx.controls.Image;
	import mx.controls.Label;
	import mx.controls.TextArea;
	import mx.core.Container;
	import mx.core.UIComponent;
	import mx.events.ListEvent;
	
	import nl.mpi.lexus.event.LexicalEntryChangeEvent;
	
	public class Editor extends EventDispatcher
	{
		[Bindable][Embed(source="/../assets/images/iconza_24x24/camera_24x24.png")]private var cameraIcon:Class;
		
		[Bindable][Embed(source="/../assets/images/iconza_24x24/film_24x24.png")]	private var filmIcon:Class;
		
		[Bindable][Embed(source="/../assets/images/iconza_24x24/sound_24x24.png")] private var soundIcon:Class;
		
		[Bindable][Embed(source="/../assets/images/iconza_24x24/globeGray_24x24.png")] private var externalLinkIcon:Class;
		
		[Bindable][Embed(source="/../assets/images/iconza_24x24/link_24x24.png")] private var internalLinkIcon:Class;	
		private var editorWidgets:Array = new Array();
		private var initialColorLevel:int = 170;
		private var instanceDataElements:Array = new Array();
		private var editor:Container;
		[Bindable]
		private var entry:Object;
		private var _crossRefElementID:String
		
		public function Editor()
		{
		}

		public function get crossRefElementID():String
		{
			return _crossRefElementID;
		}

		public function set crossRefElementID(value:String):void
		{
			_crossRefElementID = value;
		}

		public function initializeEditor( object:Object, parentContainer:Container, isEditable:Boolean, colorLevel:int):void{
			this.editor = parentContainer;
			this.editor.removeAllChildren();
			this.entry = object;
			this._initializeEditor(object, this.editor, isEditable, colorLevel);
		}
		
		 private function _initializeEditor( object:Object, parentContainer:Container, isEditable:Boolean, colorLevel:int):void{
            	this.instanceDataElements[object.id] = object;
            	
            	if( object.hasOwnProperty("children")){
            		var parentCont:Container = null;
            		if( parentContainer is GridRow){
            			parentCont = new GridItem();
            			parentCont.percentWidth = 100;
            			(parentCont as GridItem).colSpan = 2;
            			//parentCont = tmpItem;
            			parentContainer.addChild( parentCont);
            		}
            		else
            			parentCont = parentContainer;
            		var panel:Panel = new Panel();
            		this.editorWidgets[object.id]=panel;
            		panel.title = object.label;
            		panel.percentWidth=100;
            		panel.percentHeight=100;
            		panel.setStyle("paddingTop", 10);
            		panel.setStyle( "paddingLeft", 20);
            		panel.setStyle( "paddingBottom", 5);
            		
            		//var colorStr:String = "0xAFEE" + colorLevel;
            		var colorStr:String = this.getColor( colorLevel, colorLevel, colorLevel);
            		panel.setStyle("backgroundColor", colorStr);
            		
            		var grid:Grid = new Grid();
            		grid.percentWidth = 100;
            		grid.percentHeight = 100;            		
            		panel.addChild(grid);
            		for( var i:int = 0; i < object.children.length; i++){
            			var row:GridRow = new GridRow();
            			row.percentHeight=100;
            			row.percentWidth=100;
            			colorLevel =((colorLevel+8>255)? this.initialColorLevel:colorLevel +8);
            			_initializeEditor( object.children[i], row, isEditable, colorLevel);
            			grid.addChild( row);
            		}	
            		//parentCont.addChild( panel);
            		parentCont.addChildAt(panel, 0);
            	}
            	else{
            		var gridItem1:GridItem = new GridItem();
            		gridItem1.percentWidth=100;
            		var label:Label = new Label();
            		label.text =  object.label ;
            		if (object.id == this._crossRefElementID)
					{		label.setStyle("color","#B40404");
							label.setStyle("fontSize","15");
							label.setStyle("fontWeight","bold")
					}
					
					gridItem1.addChild( label);
					/**
					 *AAM: Icon handeling. 
					 * Displays an icon at the end of the datacategory name, indicating the multimedia type
					 * atached to that datacategory (if there is multimedia atached). 
					 **/ 
					
					if (object.multimedia != null){
						var icon:Image = new Image();
						
						switch (object.multimedia.type) {
							case "image":
								icon.source = cameraIcon;
								break;
							case "video":
								icon.source = filmIcon;
								break;
							case "audio":
								icon.source = soundIcon;
								break;
							case "externalURL":
								icon.source = externalLinkIcon;		
								break;
							case "url":
								icon.source = internalLinkIcon;
								break;
							default:
								trace("Cannot find multimedia icon. Unknown data type!");
								break;
						}
						
						icon.alpha =0.9;
						icon.width = 16;
						gridItem1.addChild( icon);
					}
					
            		var gridItem2:GridItem = new GridItem();
            		gridItem2.percentWidth = 100;
            		if( object.valuedomain == null){
            			var edit:TextArea = new TextArea();
            			edit.percentWidth = 100;
            			edit.percentHeight = 100;
            			edit.id = object.id;
            			this.editorWidgets[object.id]=edit;
            			
            			edit.text = object.value;
            			edit.editable = isEditable;
            			//edit.addEventListener(FocusEvent.FOCUS_IN , displayProperties);
            			edit.addEventListener(Event.CHANGE, onContentChange);
            			gridItem2.addChild( edit);
            		}
            		else{
            			var cBox:ComboBox = new ComboBox;
            			var list:ArrayCollection = new ArrayCollection();
            			for( var j:int = 0; j < object.valuedomain.length; j++){
            				var item:Object = new Object();
            				item.label = object.valuedomain[j];
            				item.data = null;
            				list.addItem( item);
            			}
            			cBox.dataProvider = list;
            			cBox.id = object.id;
            			cBox.editable = isEditable;
            			this.editorWidgets[object.id]=cBox;
						//cBox.addEventListener(FocusEvent.FOCUS_IN , displayProperties);
						cBox.addEventListener(ListEvent.CHANGE, onContentChange);

            			gridItem2.addChild( cBox); 
            		}
            		parentContainer.addChild( gridItem1);
            		parentContainer.addChild( gridItem2);
            		           		
            	}
            	
            }
            private function getColor( r:int, g:int, b:int):String{
            	return "0x" + fixedInt(rgbToInt(r, g, b), '000000'); 
            }
            private function fixedInt(value:int, mask:String):String {
                return String(mask + value.toString(16)).substr(-mask.length).toUpperCase();
            }
            private function rgbToInt(r:int, g:int, b:int):int {
                return r << 16 | g << 8 | b << 0;
            }
            private function onContentChange( event:Event):void{
            
            	//var selectedNode:Object = tree.selectedItem;
				//var widget:UIComponent = this.editorWidgets[tree.selectedItem.id];
				var widget:UIComponent = (event.target as UIComponent);
				var valueObj:Object;
				if( widget is TextArea){
					var selObj:Object = this.instanceDataElements[ widget.id];
					selObj.value = (widget as TextArea).text;
					valueObj = selObj.value;
				}
				else if( widget is ComboBox){
					var selObj1:Object = this.instanceDataElements[ widget.id];

					selObj1.value = (widget as ComboBox).selectedItem;
					valueObj = selObj1.value;
				}
				
				this.dispatchEvent( new LexicalEntryChangeEvent("change", (valueObj as String)));
            }
            
            public function setRefStyle(a_id:String):void{
				var widget:UIComponent = this.editorWidgets[a_id];
				if( editor.verticalScrollBar!=null && editor.verticalScrollBar.visible){
					widget.setStyle("color", "#FF3324");
				}}
            
            
            
            public function setFocus( a_id:String):void{
            	var widget:UIComponent = this.editorWidgets[a_id];
            	if( editor.verticalScrollBar!=null && editor.verticalScrollBar.visible){
					var p:Point = new Point( widget.x, widget.y);
					p = widget.localToGlobal( p);
					//Alert.show("Before p = " + p);
					var p1:Point = editor.globalToLocal(p); 
					//Alert.show( "Point = " + p1);
					//Alert.show( "Height=" + editor.height);
					editor.verticalScrollPosition += p1.y;
				}
				
				widget.setFocus();
            }

	}
}