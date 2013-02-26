package nl.mpi.lexus
{
	import mx.collections.*;
	import mx.controls.treeClasses.*;
	import mx.core.FlexGlobals;
	import mx.events.ToolTipEvent;
	import mx.core.IToolTip;
	import flash.geom.Point;
	import mx.core.IFactory;

    public class LexiconTreeItemRenderer extends TreeItemRenderer
    {
		private var schema:Object = null;
		
        // Define the constructor.      
        public function LexiconTreeItemRenderer() {
            super();
			// listen for the tooltip shown event
			addEventListener(ToolTipEvent.TOOL_TIP_SHOWN, toolTipShown);
        }
        
        // Override the set method for the data property
        // to set the font color and style of each node.        
        override public function set data(value:Object):void {
        	if (null == value)
        		return;
        	
            super.data = value;
        	var report:Object = FlexGlobals.topLevelApplication.modules.lexicon_browser.reportOnDataNode(super.data); 
           	if (report.errors.length > 0) {
               	setStyle("color", 0xFF0000);  
               	setStyle("fontWeight", 'bold');
	        }
            else if (report.warnings.length > 0) {
               	setStyle("color", 0xFFAA00);  
               	setStyle("fontWeight", 'bold');
           	}
           	else {
                setStyle("color", 0x000000);
                setStyle("fontWeight", 'normal');
           	}
        }
		//AAM: stuff to position the tooltip not over the highlighted node	
		public function newInstance():* {
			return new LexiconTreeItemRenderer();
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

