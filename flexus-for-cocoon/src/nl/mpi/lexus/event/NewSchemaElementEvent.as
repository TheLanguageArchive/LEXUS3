package nl.mpi.lexus.event
{
	import flash.events.Event;
	public class NewSchemaElementEvent extends Event
	{
		public var schemaElement:Object;
		
		public function NewSchemaElementEvent( type:String, schemaElement:Object)
		{
			super(type);
			this.schemaElement = schemaElement;
		}
		
		override public function clone():Event {
            return new NewSchemaElementEvent("new", this.schemaElement);
        }


	}
}