package nl.mpi.lexus.event
{
	import flash.events.Event;
	
	import mx.utils.StringUtil;

	public class NewSchemaRestrictionEvent extends Event
	{
		public var response:String;
		
		public function NewSchemaRestrictionEvent( type:String, response:String)
		{
			super(type);
			this.response=response;
		}
		
		override public function clone():Event {
            return new NewSchemaRestrictionEvent("new", this.response);
        }


	}
}