package dittner.testmyself.deutsch.view.test {
import dittner.satelliteFlight.command.CommandResult;
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.deutsch.message.TestMsg;
import dittner.testmyself.deutsch.model.domain.test.TestID;
import dittner.testmyself.deutsch.service.testFactory.TestInfo;
import dittner.testmyself.deutsch.view.test.speakWordTrans.SpeakWordTransMediator;

import flash.events.MouseEvent;

import mx.collections.ArrayCollection;

public class TestScreenMediator extends SFMediator {

	[Inject]
	public var view:TestScreen;
	private var activeTestMediator:SFMediator;

	override protected function activate():void {
		addListener(TestMsg.TEST_CANCELED_NOTIFICATION, onTestCanceled);
		sendRequest(TestMsg.GET_TEST_INFO_LIST, new RequestMessage(testsLoaded));
		view.applyTestBtn.addEventListener(MouseEvent.CLICK, onTestApplied);
	}

	private function onTestCanceled(data:* = null):void {
		if (activeTestMediator) {
			unregisterMediator(activeTestMediator);
			activeTestMediator = null;
		}
		view.clear();
	}

	private function testsLoaded(res:CommandResult):void {
		var info:Array = res.data as Array;
		view.testInfoColl = new ArrayCollection(info);
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
		view.testInfoColl = null;
		activeTestMediator = null;
		view.clear();
	}
}
}