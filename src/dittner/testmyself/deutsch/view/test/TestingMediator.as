package dittner.testmyself.deutsch.view.test {
import dittner.satelliteFlight.command.CommandResult;
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.core.message.TestMsg;
import dittner.testmyself.core.model.note.INote;
import dittner.testmyself.core.model.test.TestInfo;
import dittner.testmyself.core.model.test.TestSpec;
import dittner.testmyself.core.model.test.TestTask;
import dittner.testmyself.core.model.theme.ITheme;
import dittner.testmyself.deutsch.view.test.common.TestingAction;
import dittner.testmyself.deutsch.view.test.testingView.ITestableView;

import mx.collections.ArrayCollection;

public class TestingMediator extends SFMediator {

	[Inject]
	public var view:ITestableView;

	public var testInfo:TestInfo;
	private var testTasks:Array;

	public function TestingMediator(testInfo:TestInfo):void {
		super();
		this.testInfo = testInfo;
	}

	override protected function activate():void {
		view.actionCallback = actionCallback;
		view.answerEnabled = true;
		sendRequest(NoteMsg.GET_THEMES, new RequestMessage(onThemesLoaded));
	}

	private function actionCallback(action:String):void {
		switch (action) {
			case TestingAction.START_TEST :
				loadTasks();
				break;
			case TestingAction.ABORT_TEST :
				sendGlobalNotification(TestMsg.TEST_ABORTED_NOTIFICATION);
				break;
			case TestingAction.CORRECT_ANSWER :
				showNextTask();
				break;
			case TestingAction.INCORRECT_ANSWER :
				showNextTask();
				break;
		}
	}

	private function loadTasks():void {
		var spec:TestSpec = new TestSpec();
		spec.info = testInfo;
		spec.themes = createThemes();
		spec.audioRecordRequired = view.audioRecordRequired;
		spec.isBalancePriority = view.isBalancePriority;

		view.title = testInfo.title;

		sendRequest(TestMsg.GET_TEST_TASKS, new RequestMessage(onTasksLoaded, null, spec));
	}

	private function createThemes():Array {
		var res:Array = [];
		for each(var theme:ITheme in view.selectedThemes) res.push(theme);
		return res;
	}

	private function onTasksLoaded(res:CommandResult):void {
		testTasks = res.data as Array;
		view.taskNumber = 0;
		view.totalTask = testTasks ? testTasks.length : 0;
		showNextTask();
	}

	private var curTask:TestTask;
	private function showNextTask():void {
		if (testTasks && testTasks.length > 0) {
			curTask = testTasks.shift();
			sendRequest(NoteMsg.GET_NOTE, new RequestMessage(onNoteLoaded, null, curTask.noteID));
		}
		else view.answerEnabled = false;
	}

	private function onNoteLoaded(res:CommandResult):void {
		view.taskNumber++;
		view.activeNote = res.data as INote;
		loadExamples(view.activeNote)
	}

	private function loadExamples(note:INote):void {
		sendRequest(NoteMsg.GET_EXAMPLES, new RequestMessage(onExamplesLoaded, null, note.id));
	}

	private function onExamplesLoaded(res:CommandResult):void {
		if (res.data is Array && res.data.length > 0) {
			view.activeNoteExampleColl = new ArrayCollection(res.data as Array);
		}
		else {
			view.activeNoteExampleColl = null;
		}
	}

	private function onThemesLoaded(res:CommandResult):void {
		var themeItems:Array = res.data as Array;
		view.availableThemes = new ArrayCollection(themeItems);
	}

	override protected function deactivate():void {
		view.actionCallback = null;
		view.availableThemes = null;
		view.activeNote = null;
		view.activeNoteExampleColl = null;
		view.abort();
	}
}
}