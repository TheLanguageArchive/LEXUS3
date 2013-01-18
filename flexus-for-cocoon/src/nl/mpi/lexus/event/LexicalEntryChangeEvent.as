package nl.mpi.lexus.event
{
	import flash.events.Event;
	
	public class LexicalEntryChangeEvent extends Event
	{
		public var value:String;
		public function LexicalEntryChangeEvent( a_type:String, a_value:String)
		{
			super( a_type);
			this.value = a_value;
		}

		override public function clone():Event {
			return new LexicalEntryChangeEvent( this.type, this.value);
		}
	}
}