package nl.mpi.lexus.event
{
	import flash.events.Event;
	
	import mx.utils.StringUtil;

	public class NewSchemaRestrictionEvent extends Event
	{
		public var response:String;
		public var schemaElement:Object;
		
		public function NewSchemaRestrictionEvent( type:String, response:String, schElm:Object)
		{
			super(type);
			this.response=response;
			this.schemaElement = schElm;
		}
		
		override public function clone():Event {
            return new NewSchemaRestrictionEvent("proceed", this.response,this.schemaElement);
        }


	}
}