package events
{
	import flash.events.Event;

	public class URLUpdateEvent extends Event
	{
		public static const URL_ADDED:String = "urlAdded";
		public static const URL_DELETED:String = "urlDeleted";
		
		public var url:String;
		
		public function URLUpdateEvent(type:String, url:String = "", bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.url = url;
		}
		
		public override function clone():Event{
			return new URLUpdateEvent(type, url, bubbles, cancelable);
		} 
		
	}
}