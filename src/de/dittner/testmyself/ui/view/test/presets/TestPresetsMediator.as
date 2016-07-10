package de.dittner.testmyself.ui.view.test.presets {
import de.dittner.async.IAsyncOperation;
import de.dittner.satelliteFlight.mediator.SFMediator;
import de.dittner.satelliteFlight.message.RequestMessage;
import de.dittner.testmyself.backend.message.NoteMsg;
import de.dittner.testmyself.backend.message.TestMsg;
import de.dittner.testmyself.model.domain.common.TestID;
import de.dittner.testmyself.model.domain.test.TestInfo;
import de.dittner.testmyself.model.domain.test.TestSpec;
import de.dittner.testmyself.model.domain.test.TestTaskComplexity;
import de.dittner.testmyself.model.domain.theme.ITheme;

import flash.events.MouseEvent;

import mx.collections.ArrayCollection;

public class TestPresetsMediator extends SFMediator {

	[Inject]
	public var view:TestPresetsView;

	private var selectedTestInfo:TestInfo;

	public function TestPresetsMediator(info:TestInfo):void {
		selectedTestInfo = info;
	}

	override protected function activate():void {
		view.title = selectedTestInfo.title;
		sendRequestTo(selectedTestInfo.moduleName, NoteMsg.GET_THEMES, new RequestMessage(onThemesLoaded));
		var tid:uint = selectedTestInfo.id;
		if (tid == TestID.WRITE_WORD || tid == TestID.WRITE_LESSON || tid == TestID.WRITE_VERB_EXAMPLE || tid == TestID.WRITE_WORD_EXAMPLE) {
			view.useAudioRecordsBox.selected = true;
			view.useAudioRecordsBox.enabled = false;
		}
	}

	private function onThemesLoaded(op:IAsyncOperation):void {
		var themeItems:Array = op.result as Array;
		view.themeColl = new ArrayCollection(themeItems);
		addListeners();
	}

	private function addListeners():void {
		view.goBackBtn.addEventListener(MouseEvent.CLICK, goBackHandler);
		view.showResultsBtn.addEventListener(MouseEvent.CLICK, showResultsHandler);
		view.startTestingBtn.addEventListener(MouseEvent.CLICK, startTestingHandler);
	}

	private function goBackHandler(event:MouseEvent):void {
		sendNotification(TestMsg.SHOW_TEST_LIST_NOTIFICATION);
	}

	private function showResultsHandler(event:MouseEvent):void {
		var spec:TestSpec = createSpec();
		sendRequestTo(selectedTestInfo.moduleName, TestMsg.SELECT_TEST_SPEC, new RequestMessage(null, spec));
		sendNotification(TestMsg.SHOW_TEST_RESULTS_NOTIFICATION);
	}

	private function startTestingHandler(event:MouseEvent):void {
		var spec:TestSpec = createSpec();
		sendRequestTo(selectedTestInfo.moduleName, TestMsg.SELECT_TEST_SPEC, new RequestMessage(null, spec));
		sendNotification(TestMsg.START_TESTING_NOTIFICATION);
	}

	private function createSpec():TestSpec {
		var spec:TestSpec = new TestSpec();
		spec.info = selectedTestInfo;
		spec.filter.selectedThemes = createThemes();
		spec.audioRecordRequired = view.useAudioRecordsBox.selected;
		spec.complexity = getSelectedComplexity();
		return spec;
	}

	private function getSelectedComplexity():uint {
		if (view.middleComplexityRadioBtn.selected) return TestTaskComplexity.MIDDLE;
		else if (view.lowComplexityRadioBtn.selected) return TestTaskComplexity.LOW;
		else return TestTaskComplexity.HIGH;
	}

	private function createThemes():Array {
		var res:Array = [];
		for each(var theme:ITheme in view.themesList.selectedItems) res.push(theme);
		return res;
	}

	override protected function deactivate():void {
		selectedTestInfo = null;
		view.themeColl = null;
		removeListeners();
		view.useAudioRecordsBox.selected = false;
		view.useAudioRecordsBox.enabled = true;
	}

	private function removeListeners():void {
		view.goBackBtn.removeEventListener(MouseEvent.CLICK, goBackHandler);
		view.showResultsBtn.removeEventListener(MouseEvent.CLICK, showResultsHandler);
		view.startTestingBtn.removeEventListener(MouseEvent.CLICK, startTestingHandler);
	}

}
}