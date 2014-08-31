package dittner.satelliteFlight {
import dittner.satelliteFlight.injector.IInjector;
import dittner.satelliteFlight.message.IMessageSender;
import dittner.satelliteFlight.message.IRequestMessage;

use namespace sf_namespace;

public class SFComponent {
	public function SFComponent() {}

	sf_namespace var messageSender:IMessageSender;
	sf_namespace var injector:IInjector;
	sf_namespace var moduleName:String;

	sf_namespace function activating():void {
		activate();
	}

	//abstract
	protected function activate():void {}

	sf_namespace function deactivating():void {
		removeAllListeners();
		deactivate();
		messageSender = null;
		injector = null;
	}

	private function removeAllListeners():void {
		messageSender.removeAllListeners(this);
	}

	//abstract
	protected function deactivate():void {}

	public function sendNotification(msg:String, data:Object = null):void {
		messageSender.sendNotification(moduleName, msg, data);
	}

	public function addListener(msg:String, handler:Function):void {
		messageSender.addListener(moduleName, msg, handler, this);
	}

	public function addListenerTo(moduleName:String, msg:String, handler:Function):void {
		messageSender.addListener(moduleName, msg, handler, this);
	}

	public function removeListener(msg:String, handler:Function):void {
		messageSender.removeListener(moduleName, msg, handler, this)
	}

	public function removeListenerFrom(moduleName:String, msg:String, handler:Function):void {
		messageSender.removeListener(moduleName, msg, handler, this)
	}

	public function sendRequest(msg:String, request:IRequestMessage):void {
		messageSender.sendRequest(moduleName, msg, request);
	}

	public function sendRequestTo(moduleName:String, msg:String, request:IRequestMessage):void {
		messageSender.sendRequest(moduleName, msg, request);
	}
}
}