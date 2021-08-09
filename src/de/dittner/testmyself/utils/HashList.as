package de.dittner.testmyself.utils {

[RemoteClass(alias="de.dittner.testmyself.utils")]
public class HashList {
	public function HashList() {}

	public var values:Array = [];
	public var indexHash:Object = {};

	public function write(key:*, value:*):void {
		if (has(key)) {
			values[indexHash[key]] = value;
		}
		else {
			indexHash[key] = values.push(value) - 1;
		}
	}

	public function read(key:*):* {
		return has(key) ? values[indexHash[key]] : null;
	}

	public function clear(key:*):void {
		if (has(key)) {
			values.splice([indexHash[key], 1]);
			delete indexHash[key];
		}
	}

	public function clearAll():void {
		indexHash = {};
		values = [];
	}

	public function has(key:*):Boolean {
		return indexHash.hasOwnProperty(key);
	}

	public function getList():Array {
		return values;
	}

	public function get amount():Number {
		return values.length;
	}

	public function clone():HashList {
		var res:HashList = new HashList();
		res.values = values.concat();
		res.indexHash = indexHash;
		return res;
	}

}
}
