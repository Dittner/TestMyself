package dittner.testmyself.model.common {
import dittner.testmyself.model.model_internal;

import flash.utils.ByteArray;

use namespace model_internal;

public class TransUnit {
	public function TransUnit() {}

	//--------------------------------------
	//  id
	//--------------------------------------
	model_internal var _id:int = -1;
	public function get id():int {return _id;}

	//--------------------------------------
	//  audioRecordID
	//--------------------------------------
	model_internal var _audioRecordID:int = -1;
	public function get audioRecordID():int {return _audioRecordID;}

	//--------------------------------------
	//  audioRecord
	//--------------------------------------
	model_internal var audioRecordChanged:Boolean = false;
	model_internal var _audioRecord:ByteArray;
	public function get audioRecord():ByteArray {return _audioRecord;}
	public function set audioRecord(value:ByteArray):void {
		if (_audioRecord != value) {
			audioRecordChanged = true;
			_audioRecord = value;
		}
	}

	//--------------------------------------
	//  origin
	//--------------------------------------
	model_internal var originChanged:Boolean = false;
	model_internal var _origin:String = "";
	public function get origin():String {return _origin;}
	public function set origin(value:String):void {
		if (_origin != value) {
			originChanged = true;
			_origin = value;
		}
	}

	//--------------------------------------
	//  translation
	//--------------------------------------
	model_internal var translationChanged:Boolean = false;
	model_internal var _translation:String;
	public function get translation():String {return _translation;}
	public function set translation(value:String):void {
		if (_translation != value) {
			translationChanged = true;
			_translation = value;
		}
	}
}
}
