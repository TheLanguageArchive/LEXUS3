package nl.mpi.lexus.event
{
	import flash.events.Event;

	public class QueryEvent extends Event
	{
		
		public static const SAVE:String = "QUERY_EVENT_SAVE";
		public static const ADD:String = "QUERY_EVENT_ADD";
		public static const DELETE:String = "QUERY_EVENT_DELETE";
		public static const REFRESH:String = "QUERY_EVENT_REFRESH";
		
		private var _query:Object;
		
		public function QueryEvent(type:String, query:Object, bubbles:Boolean=true, cancelable:Boolean=true)
		{
			super(type, bubbles, cancelable);
			this._query = query;
		}
		
		public function get query():Object
		{
			return _query;
		}

		public function set query(value:Object):void
		{
			_query = value;
		}

		public override function clone():Event{
			return new QueryEvent(type, _query, bubbles, cancelable);
		} 
		
	}
}