package nl.mpi.lexus.event
{
	import flash.events.Event;

	public class ConsoleEvent extends Event
	{
		
		public static const LOG:String = "CONSOLE_LOG";
		public static const FATAL:int = 1;
		public static const ERROR:int = 2;
		public static const INFO:int = 3;
		public static const DEBUG:int = 4;
		
		public var level:int;
		public var component:String;
		public var message:String;
		
		public function ConsoleEvent(type:String, level:int, component:String = "", message:String = "", bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.level = level;
			this.component = component;
			this.message = message;
		}
		
		public override function clone():Event{
			return new ConsoleEvent(type, level, component, message, bubbles, cancelable);
		} 
		
	}
}