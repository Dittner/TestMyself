package de.dittner.testmyself.model.domain.test {
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;

public class Test {
	public function Test(id:uint, vocabulary:Vocabulary, title:String, loadExamplesWhenTesting:Boolean, isWritten:Boolean, useNoteExample:Boolean) {
		_id = id;
		_title = title;
		_loadExamplesWhenTesting = loadExamplesWhenTesting;
		_vocabulary = vocabulary;
		_isWritten = isWritten;
		_useExamples = useNoteExample;
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
	//  title
	//--------------------------------------
	private var _title:String;
	public function get title():String {return _title;}

	//--------------------------------------
	//  isWritten
	//--------------------------------------
	private var _isWritten:Boolean;
	public function get isWritten():Boolean {return _isWritten;}

	//--------------------------------------
	//  loadExamplesWhenTesting
	//--------------------------------------
	private var _loadExamplesWhenTesting:Boolean;
	public function get loadExamplesWhenTesting():Boolean {return _loadExamplesWhenTesting;}

	//--------------------------------------
	//  vocabulary
	//--------------------------------------
	private var _vocabulary:Vocabulary;
	public function get vocabulary():Vocabulary {return _vocabulary;}

	//--------------------------------------
	//  useExamples
	//--------------------------------------
	private var _useExamples:Boolean;
	public function get useExamples():Boolean {return _useExamples;}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	public function isValidForTest(note:Note):Boolean {
		if (useExamples && note.isExample)
			return isWritten ? note.hasAudioComment : true;
		else if (!useExamples && !note.isExample)
			return isWritten ? note.hasAudioComment : true;
		else return false;
	}

	private static const MSEC_INS_HOURS:Number = 5 * 60 * 60 * 1000;
	public function calcTaskRate():Number {
		return (new Date).time + Math.round(Math.random() * MSEC_INS_HOURS);
	}
}
}
