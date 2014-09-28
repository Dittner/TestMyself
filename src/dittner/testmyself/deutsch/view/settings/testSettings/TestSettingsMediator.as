package dittner.testmyself.deutsch.view.settings.testSettings {
import dittner.satelliteFlight.command.CommandResult;
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.core.message.TestMsg;
import dittner.testmyself.core.model.test.TestInfo;
import dittner.testmyself.deutsch.model.ModuleName;

import flash.events.MouseEvent;

import mx.collections.ArrayCollection;

public class TestSettingsMediator extends SFMediator {

	[Inject]
	public var view:TestSettings;

	override protected function activate():void {
		view.testColl = new ArrayCollection();
		sendRequestTo(ModuleName.WORD, TestMsg.GET_TEST_INFO_LIST, new RequestMessage(testInfoListLoaded));
		sendRequestTo(ModuleName.PHRASE, TestMsg.GET_TEST_INFO_LIST, new RequestMessage(testInfoListLoaded));
		sendRequestTo(ModuleName.VERB, TestMsg.GET_TEST_INFO_LIST, new RequestMessage(testInfoListLoaded));
		view.removeBtn.addEventListener(MouseEvent.CLICK, onTestHistoryRemoved);
	}

	private function testInfoListLoaded(res:CommandResult):void {
		for each(var item:* in res.data) view.testColl.addItem(item);
	}

	private var selectedTestInfo:TestInfo;
	private function onTestHistoryRemoved(event:MouseEvent):void {
		if (view.testList.selectedItem) {
			selectedTestInfo = view.testList.selectedItem as TestInfo;
			sendRequestTo(selectedTestInfo.moduleName, TestMsg.CLEAR_TEST_HISTORY, new RequestMessage(testHistoryCleared, null, selectedTestInfo));
		}
	}

	private function testHistoryCleared(res:CommandResult):void {
		view.testColl.removeItem(selectedTestInfo);
	}

	override protected function deactivate():void {
		view.removeBtn.removeEventListener(MouseEvent.CLICK, onTestHistoryRemoved);
	}
}
}