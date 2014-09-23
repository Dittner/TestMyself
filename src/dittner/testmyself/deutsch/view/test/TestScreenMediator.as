package dittner.testmyself.deutsch.view.test {
import dittner.satelliteFlight.command.CommandResult;
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.core.message.TestMsg;
import dittner.testmyself.core.model.test.TestInfo;
import dittner.testmyself.deutsch.message.ScreenMsg;
import dittner.testmyself.deutsch.model.ModuleName;
import dittner.testmyself.deutsch.model.domain.common.TestID;
import dittner.testmyself.deutsch.utils.pendingInvoke.doLaterInFrames;

import flash.events.MouseEvent;

import mx.collections.ArrayCollection;

public class TestScreenMediator extends SFMediator {

	[Inject]
	public var view:TestScreen;
	private var activeTestingMediator:SFMediator;
	private var activeModuleName:String;

	override protected function activate():void {
		sendRequest(ScreenMsg.LOCK, new RequestMessage());
		doLaterInFrames(activateScreen, 5);
	}

	private function activateScreen():void {
		view.activate();
		view.testInfoColl = new ArrayCollection();
		addListener(TestMsg.TEST_ABORTED_NOTIFICATION, onTestAborted);
		sendRequestTo(ModuleName.WORD, TestMsg.GET_TEST_INFO_LIST, new RequestMessage(testInfoListLoaded));
		sendRequestTo(ModuleName.PHRASE, TestMsg.GET_TEST_INFO_LIST, new RequestMessage(testInfoListLoaded));
		sendRequestTo(ModuleName.VERB, TestMsg.GET_TEST_INFO_LIST, new RequestMessage(testInfoListLoaded));
		view.applyTestBtn.addEventListener(MouseEvent.CLICK, onTestApplied);
		sendRequest(ScreenMsg.UNLOCK, new RequestMessage());
	}

	private function onTestAborted(data:* = null):void {
		unregisterTestingMediator();
		view.showTestSelectionScreen();
	}

	private function unregisterTestingMediator():void {
		if (activeTestingMediator) {
			unregisterMediatorFrom(activeModuleName, activeTestingMediator);
			activeTestingMediator = null;
			activeModuleName = "";
		}
	}

	private function testInfoListLoaded(res:CommandResult):void {
		for each(var item:* in res.data) view.testInfoColl.addItem(item);
	}

	private function onTestApplied(event:MouseEvent):void {
		if (!view.testInfoList.selectedItem) return;

		unregisterTestingMediator();

		var info:TestInfo = view.testInfoList.selectedItem as TestInfo;
		switch (info.id) {
			case TestID.SPEAK_WORD_TRANSLATION :
				activeTestingMediator = new TestingMediator(info);
				activeModuleName = ModuleName.WORD;
				registerMediatorTo(activeModuleName, view.speakWordTrans, activeTestingMediator);
				break;
		}
	}

	override protected function deactivate():void {
		view.applyTestBtn.removeEventListener(MouseEvent.CLICK, onTestApplied);
		unregisterTestingMediator();
		view.deactivate();
	}
}
}