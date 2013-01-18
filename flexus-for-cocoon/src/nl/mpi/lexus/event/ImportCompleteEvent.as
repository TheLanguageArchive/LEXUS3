package nl.mpi.lexus.event
{
	import com.adobe.net.URI;
	
	import flash.events.Event;
	
	public class ImportCompleteEvent extends Event
	{
		/**
		 * Refers to the ID for the resource, this may be a stagingFileID obtained after an upload or a pid from a archived resource
		 **/
		public var resourceId:String;
		/**
		 * Refers to the archive. Locally uploaded fles are considered to be a 'local' archive
		 **/
		public var archive: String;
		/**
		 * Refers to the fragement identifier for the resource
		 **/
		public var fragmentIdentifier: String;
		/**
		 * Refers to the url for the resource 
		 **/
		public var url:String;
		/**
		 * Refers to the source identifier. 
		 **/
		public var source:String;
		
		public function ImportCompleteEvent(type:String, resourceId:String, archive: String, fragementIdentifier:String, url:String, source:String)
		{
			super( type);
			this.resourceId = resourceId;
			this.fragmentIdentifier = fragementIdentifier;
			this.archive = archive;
			this.source = source;
		}
		
		override public function clone():Event {
            return new ImportCompleteEvent(this.type, this.resourceId, this.archive, this.fragmentIdentifier, this.url, this.source);
        }

	}
}