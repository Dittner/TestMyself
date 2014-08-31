package dittner.satelliteFlight.message {
import dittner.satelliteFlight.command.ISFCommand;
import dittner.satelliteFlight.module.RootModule;
import dittner.satelliteFlight.sf_namespace;

use namespace sf_namespace;

public class MessageSender implements IMessageSender {
	public function MessageSender(rootModule:RootModule) {
		this.rootModule = rootModule;
	}

	sf_namespace var rootModule:RootModule;

	private var handlerHash:Object = {};
	private var observerKeyHash:Object = {};

	public function addListener(moduleName:String, msg:String, handler:Function, observer:Object):void {
		var key:String = moduleName + msg;
		if (!handlerHash[key]) handlerHash[key] = [];
		handlerHash[key].push(handler);

		if (!observerKeyHash[observer]) observerKeyHash[observer] = [];
		observerKeyHash[observer].push(key);
	}

	public function sendNotification(moduleName:String, msg:String, data:Object = null):void {
		var key:String = moduleName + msg;
		if (handlerHash[key]) {
			for each(var handler:Function in handlerHash[key]) handler(data);
		}
	}

	public function removeListener(moduleName:String, msg:String, handler:Function, observer:Object):void {
		if (!observerKeyHash[observer]) return;

		var key:String = moduleName + msg;
		var keys:Array = observerKeyHash[observer];
		var i:int;
		for (i = 0; i < keys.length; i++) {
			var obsKey:String = keys[i];
			if (obsKey == key) {
				keys.splice(i, 1);

				if (handlerHash[key]) {
					var handlers:Array = handlerHash[key];
					for (i = 0; i < handlers.length; i++) {
						if (handlers[i] == handler) {
							handlers.splice(i, 1);
							break;
						}
					}
				}
			}
		}
	}

	public function removeAllListeners(observer:Object):void {
		if (!observerKeyHash[observer]) return;

		var keys:Array = observerKeyHash[observer];
		for each(var key:String in keys) {
			if (handlerHash[key]) {
				handlerHash[key].length = 0;
			}
		}
		delete observerKeyHash[observer];
	}

	public function sendRequest(moduleName:String, msg:String, request:IRequestMessage):void {
		var cmd:ISFCommand = rootModule.createModuleCommand(moduleName, msg);
		cmd.execute(request);
	}

	public function destroy():void {
		for (var msg:String in handlerHash) {
			handlerHash[msg].length = 0;
		}
		handlerHash = null;
	}
}
}
