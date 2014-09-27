package dittner.testmyself.deutsch.view.test.testing {
import dittner.satelliteFlight.command.CommandResult;
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.core.message.TestMsg;
import dittner.testmyself.core.model.note.INote;
import dittner.testmyself.core.model.test.TestInfo;
import dittner.testmyself.core.model.test.TestTask;
import dittner.testmyself.deutsch.model.domain.common.TestID;
import dittner.testmyself.deutsch.view.test.common.TestingAction;
import dittner.testmyself.deutsch.view.test.testing.test.ITestableView;

import mx.collections.ArrayCollection;

public class TestingMediator extends SFMediator {

	[Inject]
	public var view:ITestableView;

	private var selectedTestInfo:TestInfo;
	private var testTasks:Array;
	private var examplesEnabled:Boolean = false;

	public function TestingMediator(testInfo:TestInfo):void {
		super();
		selectedTestInfo = testInfo;
		switch (testInfo.id) {
			case TestID.SPEAK_PHRASE_TRANSLATION:
			case TestID.SPEAK_VERB_FORMS:
			case TestID.SPEAK_WORD_TRANSLATION:
				examplesEnabled = true;
				break;
			default :
				examplesEnabled = false;
				break;
		}
	}

	override protected function activate():void {
		view.actionCallback = actionCallback;
		view.answerEnabled = true;
		view.start();
		loadTasks();
	}

	private function actionCallback(action:String):void {
		switch (action) {
			case TestingAction.ABORT_TEST :
				sendNotification(TestMsg.SHOW_TEST_PRESETS_NOTIFICATION);
				break;
			case TestingAction.CORRECT_ANSWER :
				curTask.amount++;
				curTask.balance++;
				updateTask();
				break;
			case TestingAction.INCORRECT_ANSWER :
				curTask.amount++;
				curTask.balance--;
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

	private function onTasksLoaded(res:CommandResult):void {
		testTasks = res.data as Array;
		view.taskNumber = 0;
		view.totalTask = testTasks ? testTasks.length : 0;
		showNextTask();
	}

	private function updateTask():void {
		sendRequestTo(selectedTestInfo.moduleName, TestMsg.UPDATE_TEST_TASK, new RequestMessage(null, null, curTask));
	}

	private var curTask:TestTask;
	private function showNextTask():void {
		if (testTasks && testTasks.length > 0) {
			curTask = testTasks.shift();
			sendRequestTo(selectedTestInfo.moduleName, NoteMsg.GET_NOTE, new RequestMessage(onNoteLoaded, null, curTask.noteID));
		}
		else view.answerEnabled = false;
	}

	private function onNoteLoaded(res:CommandResult):void {
		view.taskNumber++;
		view.activeNote = res.data as INote;
		if (examplesEnabled) loadExamples(view.activeNote)
	}

	private function loadExamples(note:INote):void {
		sendRequestTo(selectedTestInfo.moduleName, NoteMsg.GET_EXAMPLES, new RequestMessage(onExamplesLoaded, null, note.id));
	}

	private function onExamplesLoaded(res:CommandResult):void {
		if (res.data is Array && res.data.length > 0) {
			view.activeNoteExampleColl = new ArrayCollection(res.data as Array);
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