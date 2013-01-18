package vicos.dynamics
{
	import flash.utils.Timer;

	// this class allows to add property-value pairs to a class instance 
	// dynamically at runtime
	 
	dynamic public class DynamicTimer extends Timer
	{
		public function DynamicTimer(delay:Number, repeatCount:int=0)
		{
			super(delay, repeatCount);
		}
		
	}
}