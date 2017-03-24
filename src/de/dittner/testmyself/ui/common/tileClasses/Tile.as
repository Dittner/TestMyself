package de.dittner.testmyself.ui.common.tileClasses {
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.Storage;
import de.dittner.walter.Walter;

import flash.display.BitmapData;
import flash.utils.ByteArray;

public class Tile {
	public function Tile(id:String) {
		if (!id) throw new Error("Empty tile id!");
		this.id = id;
	}

	//--------------------------------------
	//  id
	//--------------------------------------
	private var _id:String = "";
	public function get id():String {return _id;}
	public function set id(value:String):void {
		if (_id != value) {
			_id = value;
			cashedBitmapData = null;
		}
	}

	//--------------------------------------
	//  tileStorage
	//--------------------------------------
	private function get storage():Storage {
		return Walter.instance.getProxy("storage") as Storage;
	}

	//--------------------------------------
	//  bitmapData
	//--------------------------------------
	private var cashedBitmapData:BitmapData;
	public function get bitmapData():BitmapData {
		if (!cashedBitmapData) cashedBitmapData = storage.getTileBitmapData(id);
		return cashedBitmapData;
	}
	public function set bitmapData(value:BitmapData):void {
		cashedBitmapData = value;
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	public function store():IAsyncOperation {
		return storage.storeTile(this);
	}

	public static function encode(bitmapData:BitmapData):ByteArray {
		if (!bitmapData) throw new Error("encoding tile with null bitmapData!");
		var res:ByteArray = new ByteArray();
		res.writeInt(bitmapData.width);
		res.writeInt(bitmapData.height);
		res.writeBytes(bitmapData.getPixels(bitmapData.rect));
		return res;
	}

	public static function decode(ba:ByteArray):BitmapData {
		var res:BitmapData;
		if (ba) {
			ba.position = 0;
			var width:Number = ba.readInt();
			var height:Number = ba.readInt();
			res = new BitmapData(width, height, true, NaN);
			res.setPixels(res.rect, ba);
		}
		return res;
	}

}
}
