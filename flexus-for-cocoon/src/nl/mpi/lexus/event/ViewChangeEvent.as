package nl.mpi.lexus.event
{
	import flash.events.Event;
	public class ViewChangeEvent extends Event
	{
		private var _view:XML;
		public static const SAVED_VIEW:String = "VIEWCHANGEEVENT.SAVED"
		
		public function ViewChangeEvent(type:String, view:XML)
		{
			super(type);
			this._view = view
		}
		
		override public function clone():Event {
            return new ViewChangeEvent(this.type, this._view);
        }

		public function set view(value:XML):void {
			_view = value;
		}
		public function get view():XML {
			return _view;
		}
	}
}