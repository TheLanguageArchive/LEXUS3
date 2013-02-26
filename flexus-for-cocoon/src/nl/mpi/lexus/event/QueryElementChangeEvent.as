package nl.mpi.lexus.event
{
	import flash.events.Event;
	public class QueryElementChangeEvent extends Event
	{
		public var queryElement:Object;
		public var state:int;
		public var direction:int;
		
		public function QueryElementChangeEvent( type:String, queryElement:Object, state:int, direction:int)
		{
			super(type);
			this.queryElement = queryElement;
			this.state = state;
			this.direction = direction;
		}
		
		override public function clone():Event {
			return new QueryElementChangeEvent(this.type, this.queryElement, this.state, this.direction);
		}
		
		
	}
}