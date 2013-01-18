package nl.mpi.lexus
{
	import com.adobe.serialization.json.JSON;
	
	import flash.display.DisplayObject;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	/**
	 * A few handy functions.
	 **/
	public class LexusUtil {
		
		[Bindable]
		private static var application:Object = FlexGlobals.topLevelApplication;
		
		/**
		 * Refers to the wait popup window, only one instance
		 **/ 
		private static var popWait:WaitWindow2 = null;
		private static var timer:Timer = null;
			 
		 
		/**
		 * cut off a string at maxLength, but add '...'
		 * if the string is longer than maxLength
		 **/
		public static function cutOffString(string:String, maxLength:int):String {
			if (string.length > maxLength) 
				return string.slice(0,maxLength) + '...';
			else
				return string;
		}
		
		/*
		 * Hide the object by setting visible=false and includeInLayout=false.
		 */
		public static function hide(object:Object):void {
			object.includeInLayout = false;
			object.visible = false;
		}
		
		/*
		* Show the object by setting visible=true and includeInLayout=true.
		*/
		public static function show(object:Object):void {
			object.includeInLayout = true;
			object.visible = true;
		}

		/**
		 * Show a WaitWindow after 'after' milliseconds
		 **/	
		public static function showWait(parent:DisplayObject, infoMessage:String = "Please wait", after:int = 1000):void {
			showWaitWindow(infoMessage, after);
		}
		
		public static function showWaitWindow(infoMessage:String = "Please wait", after:int = 1000):void {
			if (popWait != null) {
				popWait.infoMessage = popWait.infoMessage + "\n" + infoMessage;
				return;
			}
			if (timer != null) {
        		trace("Timer already set! Don't know how to handle two overlapping timers. Cancel first timer before setting a new one. Removing first timer now.");
        		timer.stop();
        		timer = null;
			}
        	if (timer == null) {
        		timer = new Timer(after, 1);
        		timer.addEventListener(flash.events.TimerEvent.TIMER,
        			function():void {
    					timer = null;
            			popWait = WaitWindow2(PopUpManager.createPopUp(FlexGlobals.topLevelApplication.menuBar, WaitWindow2, false));
            			popWait.infoMessage = infoMessage;
    					PopUpManager.bringToFront(popWait);
        			}
    			);
    			timer.start();
        	}
        }
        /**
		 * Remove a WaitWindow
		 **/		
		public static function removeWait():void {
        	if (timer != null) {
        		timer.stop();
        		timer = null;
        	}
        	if (popWait != null) {
        		PopUpManager.removePopUp(popWait);
        		popWait = null;
        	}
        }
			
			
				

		/**
		 * This will parse a JSON object from the 'string'-parameter and catch any problems.
		 * If an "Unexpected < " parse error occurs it is assumed (nattevingerwerk) that the login has
		 * expired so the onError function is executed and the user is logged out. (This weird
		 * behaviour is there because of the inability of Flex to understand HTTP codes.)
		 * If any other error occurs it is reported and we apologise and THEN the onError function
		 * is executed and the user is logged out.
		 * On succes the onSucces function is called with the JSON object as the only parameter.
		 * The onFinally function is executed in the finally clause, therefore it is always
		 * executed at the end, whether or not an error occurs. onFinally doesn't get any parameters.
		 * */
		public static function parseJSON(string:String, onSucces:Function, onError:Function = null):void
		{
			var data:Object;
			
			try {
				data = (com.adobe.serialization.json.JSON.decode(string) as Object);
			} catch (error:Error) {
				/**
				 * HHV: BIG EVIL HACK! WHOOOHAHAHAHA!    (Sorry...)
				 **/
				if (error.getStackTrace().indexOf("Unexpected < ") > 0) {
					// Assume the session has expired and redirect to the login page.
					if (typeof(onError) == "function") {
						onError(error);
					}
					FlexGlobals.topLevelApplication.logout();
				}
				else {
					Alert.show("An error has occured, you'll be logged out now.\nWe're sorry for the inconvenience." +
					"\n\nThe (first part of the) error message is:\n\n" +
						error.getStackTrace().substring(0, 50),
						"Confirmation", Alert.OK, null,
						function(event:CloseEvent):void {application.logout();},
						null, Alert.OK);					
				}
			}
			onSucces(data);
		}
		
		/**
		 * This will parse a XML object from the 'string'-parameter and catch any problems.
		 * If an "Unexpected < " parse error occurs it is assumed (nattevingerwerk) that the login has
		 * expired so the onError function is executed and the user is logged out. (This weird
		 * behaviour is there because of the inability of Flex to understand HTTP codes.)
		 * If any other error occurs it is reported and we apologise and THEN the onError function
		 * is executed and the user is logged out.
		 * On succes the onSucces function is called with the JSON object as the only parameter.
		 * The onFinally function is executed in the finally clause, therefore it is always
		 * executed at the end, whether or not an error occurs. onFinally doesn't get any parameters.
		 * */
		public static function parseXML(string:String, onSucces:Function, onError:Function = null):void
		{
			var data:Object;
			
			try {
				data = new XML(string);
			} catch (error:Error) {
				/**
				 * HHV: BIG EVIL HACK! WHOOOHAHAHAHA!    (Sorry...)
				 **/
				if (error.getStackTrace().indexOf("Unexpected < ") > 0) {
					// Assume the session has expired and redirect to the login page.
					if (typeof(onError) == "function") {
						onError(error);
					}
					FlexGlobals.topLevelApplication.logout();
				}
				else {
					Alert.show("An error has occured, you'll be logged out now.\nWe're sorry for the inconvenience." +
						"\n\nThe (first part of the) error message is:\n\n" +
						error.getStackTrace().substring(0, 450),
						"Confirmation", Alert.OK, null,
						function(event:CloseEvent):void {application.logout();},
						null, Alert.OK);					
				}
			}
			onSucces(data);
		}
		
		/**
		 * This method is used to properly refresh a tree data and display.
		 **/
		public static function forceTreeRedraw(tree:AutoSizeTree, dataProvider:Object):void
		{
			var scrollPosition:Number = tree.verticalScrollPosition;
			var openItems:Object = tree.openItems;
			var selectedItem:Object = tree.selectedItem;
			tree.dataProvider = dataProvider;
			tree.openItems = openItems;
			tree.validateNow();
			if (scrollPosition > tree.maxVerticalScrollPosition)
				tree.verticalScrollPosition = tree.maxVerticalScrollPosition;
			else
				tree.verticalScrollPosition = scrollPosition;
			tree.selectedItem = selectedItem;
		}
    }
}