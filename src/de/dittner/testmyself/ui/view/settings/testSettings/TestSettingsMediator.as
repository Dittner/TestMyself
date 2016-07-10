package de.dittner.testmyself.ui.view.settings.testSettings {
import de.dittner.async.IAsyncOperation;
import de.dittner.satelliteFlight.mediator.SFMediator;
import de.dittner.satelliteFlight.message.RequestMessage;
import de.dittner.testmyself.backend.message.TestMsg;
import de.dittner.testmyself.model.ModuleName;
import de.dittner.testmyself.model.domain.test.TestInfo;

import flash.events.MouseEvent;

import mx.collections.ArrayCollection;

public class TestSettingsMediator extends SFMediator {

	[Inject]
	public var view:TestSettings;

	override protected function activate():void {
		view.testColl = new ArrayCollection();
		sendRequestTo(ModuleName.WORD, TestMsg.GET_TEST_INFO_LIST, new RequestMessage(testInfoListLoaded));
		sendRequestTo(ModuleName.VERB, TestMsg.GET_TEST_INFO_LIST, new RequestMessage(testInfoListLoaded));
		sendRequestTo(ModuleName.LESSON, TestMsg.GET_TEST_INFO_LIST, new RequestMessage(testInfoListLoaded));
		view.removeBtn.addEventListener(MouseEvent.CLICK, onTestHistoryRemoved);
	}

	private function testInfoListLoaded(op:IAsyncOperation):void {
		for each(var item:* in op.result) view.testColl.addItem(item);
	}

	private var selectedTestInfo:TestInfo;
	private function onTestHistoryRemoved(event:MouseEvent):void {
		if (view.testList.selectedItem) {
			selectedTestInfo = view.testList.selectedItem as TestInfo;
			sendRequestTo(selectedTestInfo.moduleName, TestMsg.CLEAR_TEST_HISTORY, new RequestMessage(testHistoryCleared, selectedTestInfo));
		}
	}

	private function testHistoryCleared(op:IAsyncOperation):void {
		view.testColl.removeItem(selectedTestInfo);
	}

	override protected function deactivate():void {
		view.removeBtn.removeEventListener(MouseEvent.CLICK, onTestHistoryRemoved);
	}
}
}