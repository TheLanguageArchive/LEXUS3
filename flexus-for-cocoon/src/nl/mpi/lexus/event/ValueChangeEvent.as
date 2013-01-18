package nl.mpi.lexus.event
{
	import flash.events.Event;
	public class ValueChangeEvent extends Event
	{
		public var value:Object;
		
		public function ValueChangeEvent(type:String, value:Object)
		{
			super(type);
			this.value = value;
		}
		
		override public function clone():Event {
            return new ValueChangeEvent( this.type, this.value);
        }


	}
}