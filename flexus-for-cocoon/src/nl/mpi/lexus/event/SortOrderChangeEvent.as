package nl.mpi.lexus.event
{
	import flash.events.Event;
	public class SortOrderChangeEvent extends Event
	{
		public var sortOrder:Object;
		
		
		public function SortOrderChangeEvent( type:String, sortOrder:Object)
		{
			super(type);
			this.sortOrder = sortOrder
		}
		
		override public function clone():Event {
            return new SortOrderChangeEvent(this.type, this.sortOrder);
        }


	}
}