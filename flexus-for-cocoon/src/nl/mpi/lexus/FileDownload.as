package nl.mpi.lexus {
    import flash.events.*;
    import flash.net.FileReference;
    import flash.net.URLRequest;
    
    import mx.controls.Button;
    import mx.controls.ProgressBar;
    import mx.core.UIComponent;

    public class FileDownload extends UIComponent {

        public var DOWNLOAD_URL:String;
        private var fr:FileReference;
        // Define reference to the download ProgressBar component.
		private var delegate:Object = null;
		

        public function FileDownload() {

        }

		
		/**
		 * Set references to the components, and add listeners for the OPEN,
		 * PROGRESS, and COMPLETE events.
		 */
		public function initWithDelegate(delegate:Object, dURL:String):void {
			// Set up the references to the progress bar and cancel button, which are passed from the calling script.
			this.delegate = delegate;
			DOWNLOAD_URL = dURL;
			
			fr = new FileReference();
			fr.addEventListener(Event.OPEN, openHandler);
			fr.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			fr.addEventListener(Event.COMPLETE, completeHandler);
		}
		

        /**
         * Immediately cancel the download in progress.
         */
        public function cancelDownload():void {
            fr.cancel();
        }

        /**
         * Begin downloading the file specified in the DOWNLOAD_URL constant.
         */
        public function startDownload(filename:String = ""):void {
            var request:URLRequest = new URLRequest();
            request.url = DOWNLOAD_URL;
            fr.download(request, filename);
        }

        /**
         * When the OPEN event has dispatched notify the delegate.
         */
        private function openHandler(event:Event):void {
			if (delegate.hasOwnProperty("openHandler")) 
				delegate.openHandler(event);
        }

        /**
         * While the file is downloading keep the delegate informed.
         */
        private function progressHandler(event:ProgressEvent):void {			
			if (delegate.hasOwnProperty("progressHandler")) 
				delegate.progressHandler(event);
        }

        /**
         * Once the download has completed notify the delegate.
         */
        private function completeHandler(event:Event):void {
			if (delegate.hasOwnProperty("completeHandler")) 
				delegate.completeHandler(event);
        }
    }
}
