package nl.mpi.lexus.event
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	public class ValueDomainChangeEvent extends Event
	{
		public var valueDomain:ArrayCollection;
		
		public function ValueDomainChangeEvent( type:String, valueDomain:ArrayCollection)
		{
			super(type);
			this.valueDomain = valueDomain;
		}
		
		override public function clone():Event {
            return new ValueDomainChangeEvent( this.type, this.valueDomain);
        }


	}
}