package nl.mpi.lexus.event
{
	import flash.events.Event;
	public class NewLexiconEvent extends Event
	{
		public var lexicon:Object;
		
		public function NewLexiconEvent( type:String, lexicon:Object)
		{
			super(type);
			this.lexicon = lexicon;
		}
		
		override public function clone():Event {
            return new NewLexiconEvent("new", this.lexicon);
        }


	}
}