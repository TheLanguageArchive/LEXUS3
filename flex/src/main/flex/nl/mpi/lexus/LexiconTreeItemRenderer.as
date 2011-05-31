package nl.mpi.lexus
{
	import mx.collections.*;
	import mx.controls.treeClasses.*;

    public class LexiconTreeItemRenderer extends TreeItemRenderer
    {
		private var schema:Object = null;
		
        // Define the constructor.      
        public function LexiconTreeItemRenderer() {
            super();
        }
        
        // Override the set method for the data property
        // to set the font color and style of each node.        
        override public function set data(value:Object):void {
        	if (null == value)
        		return;
        	
            super.data = value;
        	var report:Object = parentDocument.reportOnDataNode(super.data); 
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
    }
}
