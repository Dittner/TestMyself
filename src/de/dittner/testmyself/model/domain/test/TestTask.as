package de.dittner.testmyself.model.domain.test {
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.model.domain.note.Note;

import flash.events.Event;
import flash.events.EventDispatcher;

public class TestTask extends EventDispatcher {

	public function TestTask() {}

	//--------------------------------------
	//  id
	//--------------------------------------
	private var _id:int = -1;
	public function get id():int {return _id;}
	public function set id(value:int):void {_id = value;}

	//--------------------------------------
	//  test
	//--------------------------------------
	private var _test:Test;
	[Bindable("testChanged")]
	public function get test():Test {return _test;}
	public function set test(value:Test):void {
		if (_test != value) {
			_test = value;
			dispatchEvent(new Event("testChanged"));
		}
	}

	//--------------------------------------
	//  note
	//--------------------------------------
	private var _note:Note;
	[Bindable("noteChanged")]
	public function get note():Note {return _note;}
	public function set note(value:Note):void {
		if (_note != value) {
			_note = value;
			dispatchEvent(new Event("noteChanged"));
		}
	}

	//--------------------------------------
	//  rate
	//--------------------------------------
	private var _rate:Number = 0;
	[Bindable("rateChanged")]
	public function get rate():Number {return _rate;}
	public function set rate(value:Number):void {
		if (_rate != value) {
			_rate = value;
			dispatchEvent(new Event("rateChanged"));
		}
	}

	//--------------------------------------
	//  complexity
	//--------------------------------------
	private var _complexity:uint = TestTaskComplexity.HIGH;
	[Bindable("complexityChanged")]
	public function get complexity():uint {return _complexity;}
	public function set complexity(value:uint):void {
		if (_complexity != value) {
			_complexity = value;
			dispatchEvent(new Event("complexityChanged"));
		}
	}

	//--------------------------------------
	//  isFailed
	//--------------------------------------
	private var _isFailed:Boolean = false;
	[Bindable("isFailedChanged")]
	public function get isFailed():Boolean {return _isFailed;}
	public function set isFailed(value:Boolean):void {
		if (_isFailed != value) {
			_isFailed = value;
			dispatchEvent(new Event("isFailedChanged"));
		}
	}

	//--------------------------------------
	//  lastTestedDate
	//--------------------------------------
	private var _lastTestedDate:Number = 0;
	public function get lastTestedDate():Number {return _lastTestedDate;}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	public function store():IAsyncOperation {
		return test.vocabulary.storage.storeTestTask(this);
	}

	public function serialize():Object {
		var res:Object = {};
		res.testID = test.id;
		res.noteID = note.id;
		res.rate = test.calcTaskRate();
		res.complexity = complexity;
		res.isFailed = isFailed;
		res.lastTestedDate = (new Date()).time;
		return res;
	}

	private var _originalData:Object = {};
	public function get originalData():Object {return _originalData;}

	public function deserialize(data:Object):void {
		_originalData = data;
		_id = data.id;
		_rate = data.rate;
		_complexity = data.complexity;
		_isFailed = data.isFailed;
		_lastTestedDate = data.lastTestedDate;
	}

}
}
