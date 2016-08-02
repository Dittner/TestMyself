package dittner.testmyself.core.command.backend {
import flash.events.AsyncErrorEvent;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.net.SharedObject;
import flash.utils.Timer;

public class SharedObjectStorage {
	public function SharedObjectStorage() {}

	protected const STORAGE_PREF:String = "so-";

	protected var sharedObject:SharedObject;
	protected var flushTimer:Timer;
	protected var needFlush:Boolean = false;

	//--------------------------------------
	//  storageId
	//--------------------------------------
	private var _storageId:String = "";
	public function get storageId():String {return _storageId;}

	public function init(storageId:String, flushDelay:int = 1000):void {
		if (sharedObject) throw new Error("Already initialized!");
		_storageId = storageId;
		try {
			sharedObject = SharedObject.getLocal(STORAGE_PREF + storageId);
			sharedObject.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
		}
		catch (error:Error) {
			trace("Error creating shared object:" + error.message);
		}

		flushTimer = new Timer(flushDelay);
		flushTimer.addEventListener(TimerEvent.TIMER, flushNow);
		flushTimer.start();
	}

	public function dispose():void {
		if (flushTimer) flushTimer.stop();
		if (sharedObject) {
			try {
				sharedObject.close();
				sharedObject = null;
			}
			catch (error:Error) {
				trace("Error closing shared object:" + error.message);
			}
		}
	}

	public function purge():void {
		if (sharedObject) {
			try {
				var keyList:Array = [];
				for (var fieldName:String in sharedObject.data) {
					keyList.push(fieldName);
				}
				for each (var key:String in keyList) {
					delete sharedObject.data[key];
				}
				needFlush = true;
				flushNow();
			}
			catch (error:Error) {
				trace("Error closing shared object:" + error.message);
			}
		}
	}

	public function getObject(key:String):* {
		return sharedObject ? sharedObject.data[key] : null;
	}

	public function putObject(key:String, object:*):void {
		if (sharedObject) {
			sharedObject.data[key] = object;
			needFlush = true;
		}
	}

	public function deleteObject(key:String):void {
		if (sharedObject) {
			sharedObject.data[key] = null;
			delete sharedObject.data[key];
			needFlush = true;
		}
	}

	public function getStorageData():Object {
		return sharedObject ? sharedObject.data : null;
	}

	protected function asyncErrorHandler(event:AsyncErrorEvent):void {
		trace("Async error:" + event.error.message);
	}

	public function flushNow(event:Event = null):void {
		if (needFlush) {
			needFlush = false;
			if (sharedObject) {
				try {
					sharedObject.flush();
				}
				catch (err:Error) {
					trace("Error flushing shared object:" + err.message);
				}
			}
		}
	}

	public function forceFlush():void {
		needFlush = true;
		flushNow();
	}

	public function isEmpty():Boolean {
		if (sharedObject && sharedObject.data) {
			for (var p:String in sharedObject.data) return false;
		}
		return true;
	}

}
}
