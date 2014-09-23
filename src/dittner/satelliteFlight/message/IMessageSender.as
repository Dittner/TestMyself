package dittner.satelliteFlight.message {
public interface IMessageSender {
	function addListener(moduleName:String, msg:String, handler:Function, observer:Object):void;
	function removeListener(moduleName:String, msg:String, handler:Function, observer:Object):void;
	function removeAllListeners(observer:Object):void;
	function sendNotification(moduleName:String, msg:String, data:Object = null):void;
	function sendGlobalNotification(moduleName:String, msg:String, data:Object = null):void;

	function sendRequest(moduleName:String, msg:String, request:IRequestMessage):void;

	function destroy():void;
}
}
