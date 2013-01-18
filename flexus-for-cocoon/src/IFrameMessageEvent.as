package
{
	import flash.events.Event;

	public class IFrameMessageEvent extends Event
	{
		public static const EVENT_IFRAME_MESSAGE:String = "IFrameMessageEvent"		
		
		public var dataValue:Object= null;
		public var messageType:String= null;
		
		public function IFrameMessageEvent(messageType:String, dataValue:Object):void
		{
			super(EVENT_IFRAME_MESSAGE, true);
			
			this.messageType = messageType;
			this.dataValue = dataValue;
		}
	}
}

