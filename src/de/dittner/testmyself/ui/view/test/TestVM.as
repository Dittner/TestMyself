package de.dittner.testmyself.ui.view.test {
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.model.AppModel;
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
	public var storage:SQLStorage;

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
	//  curTestTask
	//--------------------------------------
	private var _curTestTask:TestTask;
	[Bindable("curTestTaskChanged")]
	public function get curTestTask():TestTask {return _curTestTask;}
	public function set curTestTask(value:TestTask):void {
		if (_curTestTask != value) {
			_curTestTask = value;
			dispatchEvent(new Event("curTestTaskChanged"));
		}
	}

	//--------------------------------------
	//  pageInfo
	//--------------------------------------
	private var _pageInfo:TestPageInfo = new TestPageInfo();
	public function get pageInfo():TestPageInfo {return _pageInfo;}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override public function viewActivated(info:ViewInfo):void {
		super.viewActivated(info);
		vocabularyColl = new ArrayCollection(appModel.selectedLanguage.vocabularyHash.getList());
		selectedVocabulary = null;
		pageInfo.test = null;
		pageInfo.selectedTheme = null;
	}

	public function storeTestTask(isFailed:Boolean, complexity:uint):void {
		curTestTask.isFailed = isFailed;
		curTestTask.complexity = complexity;
		curTestTask.lastTestedDate = (new Date).time;
		curTestTask.store();
	}

	public function loadTestTaskPageInfo():IAsyncOperation {
		pageInfo.onlyFailedNotes = false;
		pageInfo.pageSize = 1;
		var op:IAsyncOperation = storage.loadTestPageInfo(pageInfo);
		op.addCompleteCallback(function (op:IAsyncOperation):void {
			curTestTask = pageInfo.tasks && pageInfo.tasks.length > 0 ? pageInfo.tasks[0] : null;
		});
		return op;
	}

	public function loadStatisticsPageInfo():IAsyncOperation {
		pageInfo.pageSize = 10;
		return storage.loadTestPageInfo(pageInfo);
	}

	override protected function deactivate():void {}
}
}