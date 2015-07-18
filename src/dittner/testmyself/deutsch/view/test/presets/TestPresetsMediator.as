package dittner.testmyself.deutsch.view.test.presets {
import dittner.satelliteFlight.command.CommandResult;
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.core.message.TestMsg;
import dittner.testmyself.core.model.test.TestInfo;
import dittner.testmyself.core.model.test.TestSpec;
import dittner.testmyself.core.model.test.TestTaskComplexity;
import dittner.testmyself.core.model.theme.ITheme;
import dittner.testmyself.deutsch.model.domain.common.TestID;

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
		if (selectedTestInfo.id == TestID.WRITE_WORD) {
			view.useAudioRecordsBox.selected = true;
			view.useAudioRecordsBox.enabled = false;
		}
	}

	private function onThemesLoaded(res:CommandResult):void {
		var themeItems:Array = res.data as Array;
		themeItems.sortOn("name");
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
		sendRequestTo(selectedTestInfo.moduleName, TestMsg.SELECT_TEST_SPEC, new RequestMessage(null, null, spec));
		sendNotification(TestMsg.SHOW_TEST_RESULTS_NOTIFICATION);
	}

	private function startTestingHandler(event:MouseEvent):void {
		var spec:TestSpec = createSpec();
		sendRequestTo(selectedTestInfo.moduleName, TestMsg.SELECT_TEST_SPEC, new RequestMessage(null, null, spec));
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