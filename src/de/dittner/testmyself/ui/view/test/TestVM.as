package de.dittner.testmyself.ui.view.test {
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.test.TestTask;
import de.dittner.testmyself.model.domain.test.TestTaskComplexity;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;
import de.dittner.testmyself.ui.common.view.ViewModel;
import de.dittner.testmyself.ui.view.test.testing.components.TestPage;

import flash.events.Event;

import mx.collections.ArrayCollection;

public class TestVM extends ViewModel {
	public function TestVM() {
		super();
	}

	[Inject]
	public var storage:Storage;

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	//--------------------------------------
	//  vocabularyColl
	//--------------------------------------
	private var _vocabularyColl:ArrayCollection;
	[Bindable("vocabularyCollChanged")]
	public function get vocabularyColl():ArrayCollection {return _vocabularyColl;}
	public function set vocabularyColl(value:ArrayCollection):void {
		if (_vocabularyColl != value) {
			_vocabularyColl = value;
			dispatchEvent(new Event("vocabularyCollChanged"));
		}
	}

	//--------------------------------------
	//  selectedVocabulary
	//--------------------------------------
	private var _selectedVocabulary:Vocabulary;
	[Bindable("selectedVocabularyChanged")]
	public function get selectedVocabulary():Vocabulary {return _selectedVocabulary;}
	public function set selectedVocabulary(value:Vocabulary):void {
		if (_selectedVocabulary != value) {
			_selectedVocabulary = value;
			dispatchEvent(new Event("selectedVocabularyChanged"));
		}
	}

	//--------------------------------------
	//  testPage
	//--------------------------------------
	private var _testPage:TestPage;
	[Bindable("testPageChanged")]
	public function get testPage():TestPage {return _testPage;}
	private function setTestPage(value:TestPage):void {
		if (_testPage != value) {
			_testPage = value;
			dispatchEvent(new Event("testPageChanged"));
		}
	}

	//--------------------------------------
	//  taskComplexity
	//--------------------------------------
	private var _taskComplexity:uint = TestTaskComplexity.HIGH;
	[Bindable("taskComplexityChanged")]
	public function get taskComplexity():uint {return _taskComplexity;}
	public function set taskComplexity(value:uint):void {
		if (_taskComplexity != value) {
			_taskComplexity = value;
			dispatchEvent(new Event("taskComplexityChanged"));
		}
	}

	//--------------------------------------
	//  selectedTestTask
	//--------------------------------------
	private var _selectedTestTask:TestTask;
	[Bindable("selectedTestTaskChanged")]
	public function get selectedTestTask():TestTask {return _selectedTestTask;}
	public function set selectedTestTask(value:TestTask):void {
		if (_selectedTestTask != value) {
			_selectedTestTask = value;
			selectedNoteExample = null;
			dispatchEvent(new Event("selectedTestTaskChanged"));
		}
	}

	//--------------------------------------
	//  selectedNoteExample
	//--------------------------------------
	private var _selectedNoteExample:Note;
	[Bindable("selectedNoteExampleChanged")]
	public function get selectedNoteExample():Note {return _selectedNoteExample;}
	public function set selectedNoteExample(value:Note):void {
		if (_selectedNoteExample != value) {
			_selectedNoteExample = value;
			dispatchEvent(new Event("selectedNoteExampleChanged"));
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Test Fields
	//
	//----------------------------------------------------------------------------------------------

	//--------------------------------------
	//  testTaskIDs
	//--------------------------------------
	private var _testTaskIDs:Array = [];
	[Bindable("testTaskIDsChanged")]
	public function get testTaskIDs():Array {return _testTaskIDs;}
	public function set testTaskIDs(value:Array):void {
		if (_testTaskIDs != value) {
			_testTaskIDs = value;
			dispatchEvent(new Event("testTaskIDsChanged"));
		}
	}

	//--------------------------------------
	//  curTaskNumber
	//--------------------------------------
	private var _curTaskNumber:int = 0;
	[Bindable("curTaskNumberChanged")]
	public function get curTaskNumber():int {return _curTaskNumber;}
	public function set curTaskNumber(value:int):void {
		if (_curTaskNumber != value) {
			_curTaskNumber = value;
			dispatchEvent(new Event("curTaskNumberChanged"));
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override public function viewActivated(viewID:String):void {
		super.viewActivated(viewID);
		viewTitle = "TESTEN";
		selectedTestTask = null;
		if (!testPage) setTestPage(new TestPage());
		testPage.loadOnlyFailedTestTask = true;

		vocabularyColl = new ArrayCollection(appModel.selectedLanguage.vocabularyHash.getList());
		selectedVocabulary = null;
	}

	public function loadStatisticsPage():IAsyncOperation {
		selectedTestTask = null;
		return storage.loadTestStatistics(testPage);
	}

	public function loadTaskIDsForTest():IAsyncOperation {
		selectedTestTask = null;
		var op:IAsyncOperation = storage.loadTaskIDs(testPage.test, testPage.filter, taskComplexity);
		op.addCompleteCallback(taskIDsLoaded);
		return op;
	}

	private function taskIDsLoaded(op:IAsyncOperation):void {
		if (op.isSuccess) {
			curTaskNumber = 0;
			testTaskIDs = op.result || [];
		}
	}

	public function loadNextTestTask():void {
		if (curTaskNumber >= testTaskIDs.length) {
			selectedTestTask = null;
		}
		else {
			var op:IAsyncOperation = storage.loadTestTask(testPage.test, testTaskIDs[curTaskNumber++]);
			op.addCompleteCallback(testTaskLoaded);
		}
	}

	private function testTaskLoaded(op:IAsyncOperation):void {
		selectedTestTask = op.isSuccess ? op.result : null;
	}

}
}