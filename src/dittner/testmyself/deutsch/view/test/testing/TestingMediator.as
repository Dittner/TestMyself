package dittner.testmyself.deutsch.view.test.testing {
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.core.async.IAsyncOperation;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.core.message.TestMsg;
import dittner.testmyself.core.model.note.INote;
import dittner.testmyself.core.model.test.TestInfo;
import dittner.testmyself.core.model.test.TestTask;
import dittner.testmyself.deutsch.view.test.common.TestingAction;
import dittner.testmyself.deutsch.view.test.testing.test.ITestableView;

import mx.collections.ArrayCollection;

public class TestingMediator extends SFMediator {

	[Inject]
	public var view:ITestableView;

	private var selectedTestInfo:TestInfo;
	private var testTasks:Array;
	private var curTask:TestTask;

	public function TestingMediator(testInfo:TestInfo):void {
		super();
		selectedTestInfo = testInfo;
	}

	override protected function activate():void {
		addListener(TestMsg.HIDE_NOTE_FORM, hideNoteForm);
		view.actionCallback = actionCallback;
		view.answerEnabled = true;
		view.start();
		loadTasks();
	}

	private function hideNoteForm(params:* = null):void {
		reloadNote();
	}

	private function reloadNote():void {
		if (view.activeNote) {
			view.taskNumber--;
			var msg:String = selectedTestInfo.useNoteExample ? NoteMsg.GET_EXAMPLE : NoteMsg.GET_NOTE;
			sendRequestTo(selectedTestInfo.moduleName, msg, new RequestMessage(onNoteLoaded, curTask.noteID));
		}
	}

	private function actionCallback(action:String):void {
		switch (action) {
			case TestingAction.ABORT_TEST :
				sendNotification(TestMsg.SHOW_TEST_PRESETS_NOTIFICATION);
				break;
			case TestingAction.CORRECT_ANSWER :
				curTask.isFailed = false;
				updateTask();
				break;
			case TestingAction.INCORRECT_ANSWER :
				curTask.isFailed = true;
				updateTask();
				break;
			case TestingAction.NEXT_TASK :
				showNextTask();
				break;
		}
	}

	private function loadTasks():void {
		sendRequestTo(selectedTestInfo.moduleName, TestMsg.GET_TEST_TASKS, new RequestMessage(onTasksLoaded));
	}

	private function onTasksLoaded(op:IAsyncOperation):void {
		testTasks = op.result as Array;
		view.taskNumber = 0;
		view.totalTask = testTasks ? testTasks.length : 0;
		showNextTask();
	}

	private function updateTask():void {
		curTask.complexity = view.complexity;
		curTask.lastTestedDate = (new Date).time;
		sendRequestTo(selectedTestInfo.moduleName, TestMsg.UPDATE_TEST_TASK, new RequestMessage(null, curTask));
	}

	private function showNextTask():void {
		if (testTasks && testTasks.length > 0) {
			curTask = testTasks.shift();
			view.complexity = curTask.complexity;
			var msg:String = selectedTestInfo.useNoteExample ? NoteMsg.GET_EXAMPLE : NoteMsg.GET_NOTE;
			sendRequestTo(selectedTestInfo.moduleName, msg, new RequestMessage(onNoteLoaded, curTask.noteID));
		}
		else view.answerEnabled = false;
	}

	private function onNoteLoaded(op:IAsyncOperation):void {
		view.taskNumber++;
		if (op.result is INote) {
			view.activeNote = op.result as INote;
			if (selectedTestInfo.loadExamplesWhenTesting) loadExamples(view.activeNote);
			sendNotification(TestMsg.TESTING_NOTE_SELECTED, op.result as INote);
		}
		else {
			showNextTask();
		}
	}

	private function loadExamples(note:INote):void {
		sendRequestTo(selectedTestInfo.moduleName, NoteMsg.GET_EXAMPLES, new RequestMessage(onExamplesLoaded, note.id));
	}

	private function onExamplesLoaded(op:IAsyncOperation):void {
		if (op.result is Array && op.result.length > 0) {
			view.activeNoteExampleColl = new ArrayCollection(op.result as Array);
		}
		else {
			view.activeNoteExampleColl = null;
		}
	}

	override protected function deactivate():void {
		view.actionCallback = null;
		view.activeNote = null;
		view.activeNoteExampleColl = null;
		view.stop();
	}
}
}