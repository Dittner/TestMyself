package de.dittner.testmyself.ui.view.testing {
import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.model.domain.test.TestTask;
import de.dittner.testmyself.ui.common.menu.ViewID;
import de.dittner.testmyself.ui.common.page.TestPage;
import de.dittner.testmyself.ui.common.view.NoteFormViewInfo;
import de.dittner.testmyself.ui.common.view.ViewInfo;
import de.dittner.testmyself.ui.common.view.ViewModel;
import de.dittner.testmyself.ui.view.form.components.FormMode;
import de.dittner.testmyself.ui.view.form.components.FormOperationResult;

import flash.events.Event;

public class TestingVM extends ViewModel {
	public function TestingVM() {
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
	//  selectedNoteTags
	//--------------------------------------
	private var _selectedNoteTags:String = "";
	[Bindable("selectedTestTaskChanged")]
	public function get selectedNoteTags():String {return _selectedNoteTags;}

	//--------------------------------------
	//  selectedTestTask
	//--------------------------------------
	private var _selectedTestTask:TestTask;
	[Bindable("selectedTestTaskChanged")]
	public function get selectedTestTask():TestTask {return _selectedTestTask;}
	public function set selectedTestTask(value:TestTask):void {
		if (_selectedTestTask != value) {
			_selectedTestTask = value;

			_selectedNoteTags = selectedTestTask && selectedTestTask.note ? selectedTestTask.note.tagsToStr() : "";
			dispatchEvent(new Event("selectedTestTaskChanged"));
		}
	}

	//--------------------------------------
	//  errorsNum
	//--------------------------------------
	private var _errorsNum:int = 0;
	[Bindable("errorsNumChanged")]
	public function get errorsNum():int {return _errorsNum;}
	public function set errorsNum(value:int):void {
		if (_errorsNum != value) {
			_errorsNum = value;
			dispatchEvent(new Event("errorsNumChanged"));
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

	private var formEditing:Boolean = false;
	override public function viewActivated(viewInfo:ViewInfo):void {
		super.viewActivated(viewInfo);
		if(formEditing) {
			formEditing = false;
		}
		else {
			setTestPage(appModel.getTestPage());
			selectedTestTask = null;
			errorsNum = 0;
			loadTaskIDsForTest();
		}
	}

	public function loadTaskIDsForTest():IAsyncOperation {
		selectedTestTask = null;
		var op:IAsyncOperation = storage.loadTaskIDs(testPage);
		op.addCompleteCallback(taskIDsLoaded);
		return op;
	}

	private function taskIDsLoaded(op:IAsyncOperation):void {
		if (op.isSuccess) {
			curTaskNumber = 0;
			testTaskIDs = op.result || [];
			loadNextTestTask();
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

	public function editNote():void {
		formEditing = true;
		var info:NoteFormViewInfo = new NoteFormViewInfo(ViewID.NOTE_FORM);
		info.note = selectedTestTask.note;
		info.filter = testPage.selectedTag;
		info.formMode = FormMode.EDIT;
		info.callback = new AsyncOperation();
		info.callback.addCompleteCallback(noteEditComplete);
		navigateTo(info);
	}

	private function noteEditComplete(op:IAsyncOperation):void {
		if (op.isSuccess && op.result == FormOperationResult.OK) {
			loadNextTestTask();
		}
	}

	public function removeNote():void {
		formEditing = true;
		var info:NoteFormViewInfo = new NoteFormViewInfo(ViewID.NOTE_FORM);
		info.note = selectedTestTask.note;
		info.filter = testPage.selectedTag;
		info.formMode = FormMode.REMOVE;
		info.callback = new AsyncOperation();
		info.callback.addCompleteCallback(noteRemovedComplete);
		navigateTo(info);
	}

	private function noteRemovedComplete(op:IAsyncOperation):void {
		if (op.isSuccess && op.result == FormOperationResult.OK) {
			loadNextTestTask();
		}
	}

}
}