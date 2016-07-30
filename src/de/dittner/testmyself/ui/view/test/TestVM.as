package de.dittner.testmyself.ui.view.test {
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.model.AppModel;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.test.TestTask;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;
import de.dittner.testmyself.ui.common.view.ViewInfo;
import de.dittner.testmyself.ui.common.view.ViewModel;
import de.dittner.testmyself.ui.view.test.testing.components.TestPageInfo;

import flash.events.Event;

import mx.collections.ArrayCollection;

public class TestVM extends ViewModel {
	public function TestVM() {
		super();
	}

	[Inject]
	public var appModel:AppModel;
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
	//  testPage
	//--------------------------------------
	private var _testPage:TestPageInfo;
	[Bindable("testPageChanged")]
	public function get testPage():TestPageInfo {return _testPage;}
	public function set testPage(value:TestPageInfo):void {
		if (_testPage != value) {
			_testPage = value;
			dispatchEvent(new Event("testPageChanged"));
		}
	}

	//--------------------------------------
	//  statisticsPage
	//--------------------------------------
	private var _statisticsPage:TestPageInfo;
	[Bindable("statisticsPageChanged")]
	public function get statisticsPage():TestPageInfo {return _statisticsPage;}
	public function set statisticsPage(value:TestPageInfo):void {
		if (_statisticsPage != value) {
			_statisticsPage = value;
			dispatchEvent(new Event("statisticsPageChanged"));
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
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override public function viewActivated(info:ViewInfo):void {
		super.viewActivated(info);
		selectedTestTask = null;
		if (!statisticsPage) statisticsPage = new TestPageInfo();
		statisticsPage.loadOnlyFailedTestTask = true;

		if (!testPage) testPage = new TestPageInfo();
		testPage.size = 1;
		vocabularyColl = new ArrayCollection(appModel.selectedLanguage.vocabularyHash.getList());
		selectedVocabulary = null;
	}

	public function storeTestTask(isFailed:Boolean, complexity:uint):void {
		if (selectedTestTask) {
			selectedTestTask.isFailed = isFailed;
			selectedTestTask.complexity = complexity;
			selectedTestTask.lastTestedDate = (new Date).time;
			selectedTestTask.store();
		}
	}

	public function loadTestTaskPage():IAsyncOperation {
		selectedTestTask = null;
		var op:IAsyncOperation = storage.loadTestPageInfo(testPage);
		op.addCompleteCallback(function (op:IAsyncOperation):void {
			selectedTestTask = testPage.taskColl && testPage.taskColl.length > 0 ? testPage.taskColl.getItemAt(0) as TestTask : null;
		});
		return op;
	}

	public function loadStatisticsPage():IAsyncOperation {
		selectedTestTask = null;
		return storage.loadTestPageInfo(statisticsPage);
	}
}
}