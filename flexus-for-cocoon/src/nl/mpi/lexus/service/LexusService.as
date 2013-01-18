package nl.mpi.lexus.service
{
	import com.adobe.serialization.json.JSON;
	
	import mx.core.FlexGlobals;
	import mx.managers.BrowserManager;
	import mx.managers.IBrowserManager;
	import mx.messaging.SubscriptionInfo;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.utils.UIDUtil;
	
	import nl.mpi.lexus.YesNo;
	import nl.mpi.lexus.event.ConsoleEvent;
	
	public class LexusService
	{
		private var service:HTTPService;
		public var browserManager:IBrowserManager;
		
		public function LexusService()
		{
			this.service = new HTTPService();
			// this.service.useProxy = true;
			this.browserManager = BrowserManager.getInstance();
		}
		
		public function send(urlStr:String, params:Object, requesterId:String, result:Function):void {
			var jsonRequestObj:Object = new Object();
			var _reqId:String = this.getRequestId();
						
			jsonRequestObj.id=_reqId;
			jsonRequestObj.requester = requesterId;
			jsonRequestObj.parameters = params;
			var requestParam:Object = new Object();
			requestParam.request = JSON.encode(jsonRequestObj);
			var service:HTTPService = new HTTPService();
			
			urlStr = getAbsoluteURL(urlStr);
			
            service.url = urlStr;
            service.method = "POST";
            service.resultFormat = "text";
            if (result != null)
	            service.addEventListener(ResultEvent.RESULT, function(data:Object):void {
					FlexGlobals.topLevelApplication.dispatchEvent(new ConsoleEvent(ConsoleEvent.LOG, ConsoleEvent.DEBUG, "LexusService", "received from "+service.url+" : "+data.result));
					result(data);
				});
			service.addEventListener("fault", this.httpFault);
			FlexGlobals.topLevelApplication.dispatchEvent(new ConsoleEvent(ConsoleEvent.LOG, ConsoleEvent.DEBUG, "LexusService", "sending to "+service.url+" : "+requestParam.request));
            service.send(requestParam);	
		}

		public function sendXML(urlStr:String, xml:XML, result:Function):void {
//			var service:HTTPService = new HTTPService();
			
			urlStr = getAbsoluteURL(urlStr);
			
			service.url = urlStr;
			service.method = "POST";
			service.resultFormat = "text";
			service.contentType = "application/xml";
			if (result != null)
				service.addEventListener(ResultEvent.RESULT, function(data:Object):void {
					FlexGlobals.topLevelApplication.dispatchEvent(new ConsoleEvent(ConsoleEvent.LOG, ConsoleEvent.DEBUG, "LexusService", "received from "+service.url+" : "+data));
					result(data);
				});
			service.addEventListener("fault", this.httpFault);
			FlexGlobals.topLevelApplication.dispatchEvent(new ConsoleEvent(ConsoleEvent.LOG, ConsoleEvent.DEBUG, "LexusService", "sending to "+service.url));
			service.send(xml);
		}
		
		
		public function sendXMLAndParseXML(urlStr:String, xml:XML, result:Function):void {
			var service:HTTPService = new HTTPService();

			urlStr = getAbsoluteURL(urlStr);
			
			service.url = urlStr;
			service.method = "POST";
			service.resultFormat = "text";
			service.contentType = "application/xml";
			if (result != null)
				service.addEventListener(ResultEvent.RESULT, function(event:ResultEvent):void {
					FlexGlobals.topLevelApplication.dispatchEvent(new ConsoleEvent(ConsoleEvent.LOG, ConsoleEvent.DEBUG, "LexusService", "received from "+service.url+" : "+event.result));
					result(new XML(event.result));
				});
			service.addEventListener("fault", this.httpFault);
			FlexGlobals.topLevelApplication.dispatchEvent(new ConsoleEvent(ConsoleEvent.LOG, ConsoleEvent.DEBUG, "LexusService", "sending to "+service.url));
			service.send(xml);
		}
		
		public function getXML(urlStr:String, result:Function):void {
			var service:HTTPService = new HTTPService();
			
			urlStr = getAbsoluteURL(urlStr);
			
			service.url = urlStr;
			service.method = "GET";
			service.resultFormat = "text";
			service.contentType = "application/xml";
			if (result != null)
				service.addEventListener(ResultEvent.RESULT, function(event:ResultEvent):void {
					FlexGlobals.topLevelApplication.dispatchEvent(new ConsoleEvent(ConsoleEvent.LOG, ConsoleEvent.DEBUG, "LexusService", "received from "+service.url+" : "+event.result));
					result(event);
				});
			service.addEventListener("fault", this.httpFault);
			FlexGlobals.topLevelApplication.dispatchEvent(new ConsoleEvent(ConsoleEvent.LOG, ConsoleEvent.DEBUG, "LexusService", "sending to "+service.url));
			service.send();
		}
		/**
		 * Fault Handler for the HTTP request
		 **/
		public function httpFault(event:FaultEvent):void {
            YesNo.info("HTTP ERROR,\nfirst part of message=" + event.message.toString().substr(0, 50));            
        }

		/**
		 * Returns an unique requestID
		 **/
		public function getRequestId():String{
			return UIDUtil.createUID();
		}

		
		public function getAbsoluteURL(urlStr:String):String {
			return LexusService.getAbsoluteURL(urlStr);
		}
		public static function getAbsoluteURL(urlStr:String):String {
			// When launched from Flexbuilder,
			// substitute 'file://...' with 'http://localhost:8080/'
			// It would be better to have a parameter that is
			// set whenever Maven is in dev mode.
			var url:String = BrowserManager.getInstance().url;
			if (url) {
				var protocol:String = mx.utils.URLUtil.getProtocol(url);
				if (protocol) { // HHV: Strictly for easy debugging, when running from Flex.
					if (protocol == "file") {
//						urlStr = "http://localhost:8080/lexusDojo/" + urlStr;
						urlStr = "http://localhost:8888/mpi/lexusDojo/" + urlStr;
					}
				}
			}
			return urlStr;
		}
	}
}