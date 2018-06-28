package de.dittner.testmyself.model.domain.test {
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.model.domain.domain_internal;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;
import de.dittner.testmyself.utils.ActualDate;

use namespace domain_internal;

public class Test {
	public function Test(id:uint, vocabulary:Vocabulary, title:String) {
		_id = id;
		_title = title;
		_vocabulary = vocabulary;
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	//--------------------------------------
	//  id
	//--------------------------------------
	private var _id:uint;
	public function get id():uint {return _id;}

	//--------------------------------------
	//  vocabulary
	//--------------------------------------
	private var _vocabulary:Vocabulary;
	public function get vocabulary():Vocabulary {return _vocabulary;}

	//--------------------------------------
	//  title
	//--------------------------------------
	private var _title:String;
	public function get title():String {return _title;}

	//--------------------------------------
	//  loadExamplesWhenTesting
	//--------------------------------------
	domain_internal var _loadExamplesWhenTesting:Boolean;
	public function get loadExamplesWhenTesting():Boolean {return _loadExamplesWhenTesting;}

	//--------------------------------------
	//  isWritten
	//--------------------------------------
	domain_internal var _isWritten:Boolean;
	public function get isWritten():Boolean {return _isWritten;}

	//--------------------------------------
	//  useExamples
	//--------------------------------------
	domain_internal var _useExamples:Boolean = false;
	public function get useExamples():Boolean {return _useExamples;}

	//--------------------------------------
	//  translateFromNativeIntoForeign
	//--------------------------------------
	domain_internal var _translateFromNativeIntoForeign:Boolean = false;
	public function get translateFromNativeIntoForeign():Boolean {return _translateFromNativeIntoForeign;}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	public function isValidForTest(note:Note):Boolean {
		if (useExamples && note.isExample)
			return isWritten ? note.hasAudio : true;
		else if (!useExamples && !note.isExample)
			return isWritten ? note.hasAudio : true;
		else return false;
	}

	private static const MSEC_INS_HOURS:Number = 5 * 60 * 60 * 1000;
	public function calcTaskRate():Number {
		return ActualDate.time + Math.round(Math.random() * MSEC_INS_HOURS);
	}

	public function createTestTask():TestTask {
		var res:TestTask = new TestTask();
		res.test = this;
		return res;
	}

	public function clearHistory():IAsyncOperation {
		var op:IAsyncOperation = vocabulary.storage.clearTestHistory(this);
		return op;
	}
}
}
