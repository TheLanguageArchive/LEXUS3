package nl.mpi.lexus.event
{
	import com.adobe.net.URI;
	
	import flash.events.Event;
	
	public class ReferenceAttachCompleteEvent extends Event
	{
		
		
		/**
		 * Refers to the ID for the lexicon that is cross-referenced with one of its elements
		 **/
		public var referenceId:String;
		
		public function ReferenceAttachCompleteEvent(type:String, referenceId:String)
		{
			super( type);
			this.referenceId = referenceId;
			
		}
		
		override public function clone():Event {
            return new ReferenceAttachCompleteEvent(this.type,this.referenceId);
        }

	}
}