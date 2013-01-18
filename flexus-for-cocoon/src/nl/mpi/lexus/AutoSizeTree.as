/**
 * AAM: This component extends the Flex Tree for measuring the width of all the renderers so the scrollbars are calculated correctly. 
 *  It fixes a bug with the horizontal scroolbars in the Flex Tree component. See LEXUS bug 314.
 *  The problem is that in a Tree (and other List-based components), when you set the horizontalScrollPolicy to auto, 
 * the scrollbars actually don't come out when they should.
 *  Adobe classifies this as a design option due to performance issues (see https://bugs.adobe.com/jira/browse/SDK-9645)
 * and one of their developers proposes this module as a solution for use cases similar to ours.
 *  This component should be used insted of the original Tree every time horizontall scrollbar problems are found,
 * it can also be used under normal circunstances.
 */



package nl.mpi.lexus{
	import flash.events.Event;
	
	import mx.controls.Tree;
	import mx.core.mx_internal;
	import mx.core.ScrollPolicy;
	import mx.events.TreeEvent;
	
	public class AutoSizeTree extends Tree
	{
		public function AutoSizeTree(){
			super();
			horizontalScrollPolicy = ScrollPolicy.AUTO;
		}
		
		/**
		 *AAM: original coments (bellow) by Ryan Frishberg (Adobe Flex SDK developer). 
		 */
		
		// we need to override maxHorizontalScrollPosition because setting
		// Tree's maxHorizontalScrollPosition adds an indent value to it,
		// which we don't need as measureWidthOfItems seems to return exactly
		// what we need.  Not only that, but getIndent() seems to be broken
		// anyways (SDK-12578).
		
		// I hate using mx_internal stuff, but we can't do
		// super.super.maxHorizontalScrollPosition in AS 3, so we have to
		// emulate it.
		override public function get maxHorizontalScrollPosition():Number
		{
			if (isNaN(mx_internal::_maxHorizontalScrollPosition))
				return 0;
			
			return mx_internal::_maxHorizontalScrollPosition;
		}
		
		override public function set maxHorizontalScrollPosition(value:Number):void
		{
			mx_internal::_maxHorizontalScrollPosition = value;
			dispatchEvent(new Event("maxHorizontalScrollPositionChanged"));
			
			scrollAreaChanged = true;
			invalidateDisplayList();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			// we call measureWidthOfItems to get the max width of the item renderers.
			// then we see how much space we need to scroll, setting maxHorizontalScrollPosition appropriately
			var diffWidth:Number = measureWidthOfItems(0,0) - (unscaledWidth - viewMetrics.left - viewMetrics.right);
			
			if (diffWidth <= 0)             
				maxHorizontalScrollPosition = NaN;      
			else                
				maxHorizontalScrollPosition = diffWidth;      
			super.updateDisplayList(unscaledWidth, unscaledHeight);     
		}   
	} 
}