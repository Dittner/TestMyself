package dittner.testmyself.deutsch.view.test.results {
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.core.async.IAsyncOperation;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.core.message.TestMsg;
import dittner.testmyself.core.model.note.INote;
import dittner.testmyself.core.model.page.ITestPageInfo;
import dittner.testmyself.core.model.page.TestPageInfo;
import dittner.testmyself.core.model.test.TestInfo;
import dittner.testmyself.deutsch.model.domain.common.TestID;
import dittner.testmyself.deutsch.view.common.list.SelectableDataGroup;
import dittner.testmyself.deutsch.view.common.pagination.PaginationBar;
import dittner.testmyself.deutsch.view.test.common.TestRendererData;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.collections.ArrayCollection;

public class TestingResultsMediator extends SFMediator {

	[Inject]
	public var view:TestingResultsView;
	private var selectedTestInfo:TestInfo;
	private var needTranslationInvert:Boolean = false;

	public function TestingResultsMediator(testInfo:TestInfo):void {
		super();
		selectedTestInfo = testInfo;
		switch (testInfo.id) {
			case TestID.SPEAK_WORD_IN_DEUTSCH:
			case TestID.SPEAK_LESSON_IN_DEUTSCH:
			case TestID.SPEAK_VERB_EXAMPLE_IN_DEUTSCH:
			case TestID.SPEAK_WORD_EXAMPLE_IN_DEUTSCH:
				needTranslationInvert = true;
				break;
			default :
				needTranslationInvert = false;
				break;
		}
	}

	private function get paginationBar():PaginationBar {
		return view.paginationBar;
	}

	override protected function activate():void {
		view.title = selectedTestInfo.title;
		view.list.addEventListener(SelectableDataGroup.SELECTED, taskSelectedHandler);
		view.goBackBtn.addEventListener(MouseEvent.CLICK, goBackClickHandler);
		view.lastFailedNotesFilterBox.addEventListener(Event.CHANGE, onlyFailedNotesFilterChanged);
		sendRequestTo(selectedTestInfo.moduleName, TestMsg.GET_TEST_PAGE_INFO, new RequestMessage(onPageInfoLoaded, createTestPageInfo()));
		sendRequestTo(selectedTestInfo.moduleName, TestMsg.GET_TEST_TASKS_AMOUNT, new RequestMessage(onTestTasksAmountLoaded, onlyFailedNotes));
		paginationBar.nextPageBtn.addEventListener(MouseEvent.CLICK, nextPageBtnClickHandler);
		paginationBar.prevPageBtn.addEventListener(MouseEvent.CLICK, prevPageBtnClickHandler);
		paginationBar.firstPageBtn.addEventListener(MouseEvent.CLICK, firstPageBtnClickHandler);
		paginationBar.lastPageBtn.addEventListener(MouseEvent.CLICK, lastPageBtnClickHandler);
	}

	private function onlyFailedNotesFilterChanged(event:Event):void {
		sendRequestTo(selectedTestInfo.moduleName, TestMsg.GET_TEST_PAGE_INFO, new RequestMessage(onPageInfoLoaded, createTestPageInfo()));
		sendRequestTo(selectedTestInfo.moduleName, TestMsg.GET_TEST_TASKS_AMOUNT, new RequestMessage(onTestTasksAmountLoaded, onlyFailedNotes));
	}

	private function get onlyFailedNotes():Boolean {
		return view.lastFailedNotesFilterBox.selected;
	}

	private function createTestPageInfo(pageNum:uint = 0):TestPageInfo {
		var res:TestPageInfo = new TestPageInfo();
		res.pageNum = pageNum;
		res.onlyFailedNotes = onlyFailedNotes;
		return res;
	}

	private function onPageInfoLoaded(op:IAsyncOperation):void {
		updateView(op.result as ITestPageInfo);
	}

	private function updateView(info:ITestPageInfo):void {
		paginationBar.notesOnPage = info.notes.length;
		paginationBar.curPageNum = info.pageNum;
		paginationBar.pageSize = info.pageSize;

		var rendererData:Array = wrapNotesAndTasks(info.notes, info.tasks);
		view.list.selectedItem = null;
		view.dataProvider = new ArrayCollection(rendererData);
	}

	private function wrapNotesAndTasks(notes:Array, tasks:Array):Array {
		var res:Array = [];
		for (var i:int = 0; i < tasks.length; i++) {
			if (!notes[i]) continue;
			res.push(new TestRendererData(notes[i], tasks[i], needTranslationInvert));
		}
		return res;
	}

	private function onTestTasksAmountLoaded(op:IAsyncOperation):void {
		paginationBar.totalNotes = op.result as uint;
	}

	//--------------------------------------
	//  pagination
	//--------------------------------------

	private function nextPageBtnClickHandler(event:MouseEvent):void {
		loadPageInfo(paginationBar.curPageNum + 1);
	}

	private function prevPageBtnClickHandler(event:MouseEvent):void {
		loadPageInfo(paginationBar.curPageNum - 1);
	}

	private function firstPageBtnClickHandler(event:MouseEvent):void {
		loadPageInfo(0);
	}

	private function lastPageBtnClickHandler(event:MouseEvent):void {
		loadPageInfo(paginationBar.totalPages - 1);
	}

	private function loadPageInfo(pageNum:uint):void {
		sendRequestTo(selectedTestInfo.moduleName, TestMsg.GET_TEST_PAGE_INFO, new RequestMessage(onPageInfoLoaded, createTestPageInfo(pageNum)));
	}

	private function goBackClickHandler(event:MouseEvent):void {
		sendNotification(TestMsg.SHOW_TEST_PRESETS_NOTIFICATION);
	}

	//--------------------------------------
	//  examples
	//--------------------------------------

	private function taskSelectedHandler(event:Event):void {
		var renData:TestRendererData = view.list.selectedItem as TestRendererData;
		if (renData && selectedTestInfo.loadExamplesWhenTesting) loadExamples(renData.note);
		else hideList();
	}

	private function loadExamples(note:INote):void {
		sendRequestTo(selectedTestInfo.moduleName, NoteMsg.GET_EXAMPLES, new RequestMessage(onExamplesLoaded, note.id));
	}

	protected function onExamplesLoaded(op:IAsyncOperation):void {
		if (op.result is Array && op.result.length > 0) {
			view.exampleList.dataProvider = new ArrayCollection(op.result as Array);
			view.exampleList.visible = view.exampleList.includeInLayout = true;
		}
		else {
			hideList();
		}
	}

	private function hideList():void {
		view.exampleList.dataProvider = null;
		view.exampleList.visible = view.exampleList.includeInLayout = false;
	}

	override protected function deactivate():void {
		view.list.removeEventListener(SelectableDataGroup.SELECTED, taskSelectedHandler);
		view.goBackBtn.removeEventListener(MouseEvent.CLICK, goBackClickHandler);
		view.lastFailedNotesFilterBox.removeEventListener(Event.CHANGE, onlyFailedNotesFilterChanged);
		paginationBar.nextPageBtn.removeEventListener(MouseEvent.CLICK, nextPageBtnClickHandler);
		paginationBar.prevPageBtn.removeEventListener(MouseEvent.CLICK, prevPageBtnClickHandler);
		paginationBar.firstPageBtn.removeEventListener(MouseEvent.CLICK, firstPageBtnClickHandler);
		paginationBar.lastPageBtn.removeEventListener(MouseEvent.CLICK, lastPageBtnClickHandler);
	}

}
}