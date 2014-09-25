package dittner.testmyself.deutsch.view.test.testList {
import dittner.satelliteFlight.command.CommandResult;
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.core.message.TestMsg;
import dittner.testmyself.deutsch.model.ModuleName;

import flash.events.MouseEvent;

import mx.collections.ArrayCollection;

public class TestListMediator extends SFMediator {

	[Inject]
	public var view:TestListView;

	override protected function activate():void {
		view.testInfoColl = new ArrayCollection();
		sendRequestTo(ModuleName.WORD, TestMsg.GET_TEST_INFO_LIST, new RequestMessage(testInfoListLoaded));
		sendRequestTo(ModuleName.PHRASE, TestMsg.GET_TEST_INFO_LIST, new RequestMessage(testInfoListLoaded));
		sendRequestTo(ModuleName.VERB, TestMsg.GET_TEST_INFO_LIST, new RequestMessage(testInfoListLoaded));
		view.applyTestBtn.addEventListener(MouseEvent.CLICK, onTestApplied);
	}

	private function testInfoListLoaded(res:CommandResult):void {
		for each(var item:* in res.data) view.testInfoColl.addItem(item);
	}

	private function onTestApplied(event:MouseEvent):void {
		if (view.testInfoList.selectedItem) {
			sendNotification(TestMsg.TEST_INFO_SELECTED_NOTIFICATION, view.testInfoList.selectedItem);
			sendNotification(TestMsg.SHOW_TEST_PRESETS_NOTIFICATION);
		}
	}

	override protected function deactivate():void {
		view.applyTestBtn.removeEventListener(MouseEvent.CLICK, onTestApplied);
	}
}
}