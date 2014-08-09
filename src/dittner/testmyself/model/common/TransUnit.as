package dittner.testmyself.model.common {

import flash.utils.ByteArray;

public class TransUnit implements ITransUnit {
	public function TransUnit() {}

	//--------------------------------------
	//  id
	//--------------------------------------
	private var _id:int = -1;
	public function get id():int {return _id;}
	public function set id(value:int):void {_id = value;}

	//--------------------------------------
	//  audioRecordID
	//--------------------------------------
	private var _audioRecordID:int = -1;
	public function get audioRecordID():int {return _audioRecordID;}
	public function set audioRecordID(value:int):void {_audioRecordID = value;}

	//--------------------------------------
	//  audioRecord
	//--------------------------------------
	private var _audioRecord:ByteArray;
	public function get audioRecord():ByteArray {return _audioRecord;}
	public function set audioRecord(value:ByteArray):void {_audioRecord = value;}

	//--------------------------------------
	//  origin
	//--------------------------------------
	private var _origin:String = "";
	public function get origin():String {return _origin;}
	public function set origin(value:String):void {_origin = value;}

	//--------------------------------------
	//  translation
	//--------------------------------------
	private var _translation:String;
	public function get translation():String {return _translation;}
	public function set translation(value:String):void {_translation = value;}
}
}
