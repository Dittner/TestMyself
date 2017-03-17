package de.dittner.testmyself.backend.utils {
import de.dittner.async.utils.clearDelay;
import de.dittner.async.utils.doLaterInSec;
import de.dittner.testmyself.backend.Storage;
import de.dittner.walter.Walter;

public class HashData {
	public function HashData() {}

	public var key:String = "";
	public var data:Object = {};
	public var isStored:Boolean = false;

	public function write(key:String, value:*):void {
		if (data[key] != value) {
			data[key] = value;
			store();
		}
	}

	public function read(key:String):* {
		return data[key];
	}

	public function clear(key:String):void {
		if (data[key]) {
			delete data[key];
			store();
		}
	}

	public function clearAll():void {
		data = {};
		store();
	}

	private var lastStoreIndex:Number;
	private function store():void {
		if (!isNaN(lastStoreIndex))
			clearDelay(lastStoreIndex);
		lastStoreIndex = doLaterInSec(deferredStore, 3)
	}

	private function deferredStore():void {
		lastStoreIndex = NaN;
		if (Walter.instance.getProxy("storage"))
			(Walter.instance.getProxy("storage") as Storage).store(this);
		else
			throw new Error("No Storage proxy!");
	}

}
}
