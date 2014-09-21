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
import dittner.testmyself.deutsch.view.test.speakWordTrans.SpeakWordTransMediator;

import flash.events.MouseEvent;

import mx.collections.ArrayCollection;

public class TestScreenMediator extends SFMediator {

	[Inject]
	public var view:TestScreen;
	private var activeTestMediator:SFMediator;

	override protected function activate():void {
		sendRequest(ScreenMsg.LOCK, new RequestMessage());
		doLaterInFrames(activateScreen, 5);
	}

	private function activateScreen():void {
		view.activate();
		view.testInfoColl = new ArrayCollection();
		addListener(TestMsg.TEST_CANCELED_NOTIFICATION, onTestCanceled);
		sendRequestTo(ModuleName.WORD, TestMsg.GET_TEST_INFO_LIST, new RequestMessage(testInfoListLoaded));
		sendRequestTo(ModuleName.PHRASE, TestMsg.GET_TEST_INFO_LIST, new RequestMessage(testInfoListLoaded));
		sendRequestTo(ModuleName.VERB, TestMsg.GET_TEST_INFO_LIST, new RequestMessage(testInfoListLoaded));
		view.applyTestBtn.addEventListener(MouseEvent.CLICK, onTestApplied);
		sendRequest(ScreenMsg.UNLOCK, new RequestMessage());
	}

	private function onTestCanceled(data:* = null):void {
		if (activeTestMediator) {
			unregisterMediator(activeTestMediator);
			activeTestMediator = null;
		}
		view.showTestSelectionScreen();
	}

	private function testInfoListLoaded(res:CommandResult):void {
		for each(var item:* in res.data) view.testInfoColl.addItem(item);
	}

	private function onTestApplied(event:MouseEvent):void {
		if (!view.testInfoList.selectedItem) return;

		if (activeTestMediator) {
			unregisterMediator(activeTestMediator);
			activeTestMediator = null;
		}

		var selectedTestID:uint = (view.testInfoList.selectedItem as TestInfo).id;
		var mediator:SFMediator;
		switch (selectedTestID) {
			case TestID.SPEAK_WORD_TRANSLATION :
				mediator = new SpeakWordTransMediator();
				break;
		}
		if (mediator) {
			activeTestMediator = mediator;
			registerMediator(view.speakWordTrans, mediator);
		}
	}

	override protected function deactivate():void {
		view.applyTestBtn.removeEventListener(MouseEvent.CLICK, onTestApplied);
		activeTestMediator = null;
		view.deactivate();
	}
}
}