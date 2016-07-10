package de.dittner.testmyself.ui.view.test {
import de.dittner.async.utils.doLaterInFrames;
import de.dittner.satelliteFlight.mediator.SFMediator;
import de.dittner.satelliteFlight.message.RequestMessage;
import de.dittner.testmyself.backend.message.TestMsg;
import de.dittner.testmyself.model.domain.test.TestInfo;
import de.dittner.testmyself.ui.message.ScreenMsg;
import de.dittner.testmyself.ui.view.test.form.TestingNoteFormMediator;
import de.dittner.testmyself.ui.view.test.presets.TestPresetsMediator;
import de.dittner.testmyself.ui.view.test.results.TestingResultsMediator;
import de.dittner.testmyself.ui.view.test.testList.TestListMediator;
import de.dittner.testmyself.ui.view.test.testing.TestingMediator;

import flash.events.MouseEvent;

public class TestScreenMediator extends SFMediator {

	[Inject]
	public var view:TestScreen;

	private var presetsMediator:TestPresetsMediator;
	private var testingMediator:TestingMediator;
	private var resultsMediator:TestingResultsMediator;
	private var noteFormMediator:TestingNoteFormMediator;
	private var selectedTestInfo:TestInfo;

	override protected function activate():void {
		view.editForm.visible = false;
		addListener(TestMsg.TEST_INFO_SELECTED_NOTIFICATION, testInfoSelected);
		addListener(TestMsg.SHOW_TEST_PRESETS_NOTIFICATION, showTestPresets);
		addListener(TestMsg.SHOW_TEST_LIST_NOTIFICATION, showTestList);
		addListener(TestMsg.SHOW_TEST_RESULTS_NOTIFICATION, showTestResults);
		addListener(TestMsg.START_TESTING_NOTIFICATION, startTesting);
		sendRequest(ScreenMsg.LOCK, new RequestMessage());
		doLaterInFrames(activateScreen, 5);
	}

	private function testInfoSelected(testInfo:TestInfo):void {
		selectedTestInfo = testInfo;
	}

	private function activateScreen():void {
		view.activate();
		view.editBtn.addEventListener(MouseEvent.CLICK, editTestingNote);
		view.removeBtn.addEventListener(MouseEvent.CLICK, removeTestingNote);
		registerMediator(view.testListView, new TestListMediator());
		sendRequest(ScreenMsg.UNLOCK, new RequestMessage());
	}

	private function editTestingNote(event:MouseEvent):void {
		if (noteFormMediator) noteFormMediator.startEditing();
	}

	private function removeTestingNote(event:MouseEvent):void {
		if (noteFormMediator) noteFormMediator.startRemoving();
	}

	private function showTestPresets(params:* = null):void {
		if (!presetsMediator) {
			presetsMediator = new TestPresetsMediator(selectedTestInfo);
			registerMediator(view.testPresetsView, presetsMediator);
		}
		view.showTestPresets();
	}

	private function showTestList(params:* = null):void {
		unregisterMediators();
		view.showTestList();
	}

	private function showTestResults(params:* = null):void {
		unregisterMediators();
		if (!resultsMediator) {
			resultsMediator = new TestingResultsMediator(selectedTestInfo);
			registerMediator(view.testingResultsView, resultsMediator);
		}
		view.showTestingResults();
	}

	private function startTesting(params:* = null):void {
		unregisterMediators();
		if (!testingMediator) {
			view.testingView.activate(selectedTestInfo);
			testingMediator = new TestingMediator(selectedTestInfo);
			registerMediator(view.testingView.activeView, testingMediator);
		}
		if (noteFormMediator) unregisterMediatorFrom(noteFormMediator.moduleName, noteFormMediator);
		else noteFormMediator = new TestingNoteFormMediator();
		noteFormMediator.selectedTestInfo = selectedTestInfo;
		registerMediatorTo(selectedTestInfo.moduleName, view.editForm, noteFormMediator);
		view.showTesting();
	}

	private function unregisterMediators():void {
		if (presetsMediator) {
			unregisterMediator(presetsMediator);
			presetsMediator = null;
		}
		if (testingMediator) {
			unregisterMediator(testingMediator);
			testingMediator = null;
		}
		if (resultsMediator) {
			unregisterMediator(resultsMediator);
			resultsMediator = null;
		}
	}

	override protected function deactivate():void {
		view.deactivate();
		view.editBtn.removeEventListener(MouseEvent.CLICK, editTestingNote);
		view.removeBtn.removeEventListener(MouseEvent.CLICK, removeTestingNote);
		presetsMediator = null;
	}
}
}