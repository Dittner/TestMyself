package dittner.testmyself.model.common {
import dittner.testmyself.model.model_internal;

use namespace model_internal;

public class DataBaseInfoVo {
	public function DataBaseInfoVo() {
	}

	//--------------------------------------
	//  wodsNum
	//--------------------------------------
	model_internal var _wodsNum:uint = 0;
	public function get wodsNum():uint {return _wodsNum;}

	//--------------------------------------
	//  phrasesNum
	//--------------------------------------
	model_internal var _phrasesNum:uint = 0;
	public function get phrasesNum():uint {return _phrasesNum;}

	//--------------------------------------
	//  strongVerbsNum
	//--------------------------------------
	model_internal var _strongVerbsNum:uint = 0;
	public function get strongVerbsNum():uint {return _strongVerbsNum;}

	//--------------------------------------
	//  examplesNum
	//--------------------------------------
	model_internal var _examplesNum:uint = 0;
	public function get examplesNum():uint {return _examplesNum;}

	//--------------------------------------
	//  audioRecordsNum
	//--------------------------------------
	model_internal var _audioRecordsNum:uint = 0;
	public function get audioRecordsNum():uint {return _audioRecordsNum;}

}
}
