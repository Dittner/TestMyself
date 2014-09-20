package dittner.testmyself.deutsch.view.test.speakWordTrans {
import dittner.satelliteFlight.command.CommandResult;
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.deutsch.message.TestMsg;
import dittner.testmyself.deutsch.model.ModuleName;

import flash.events.MouseEvent;

import mx.collections.ArrayCollection;

public class SpeakWordTransMediator extends SFMediator {

	[Inject]
	public var view:SpeakWordTrans;

	override protected function activate():void {
		view.cancelBtn.addEventListener(MouseEvent.CLICK, onCanceled);
		sendRequestTo(ModuleName.WORD, NoteMsg.GET_THEMES, new RequestMessage(onThemesLoaded));
	}

	protected function onThemesLoaded(res:CommandResult):void {
		var themeItems:Array = res.data as Array;
		view.themeColl = new ArrayCollection(themeItems);
	}

	private function onCanceled(event:MouseEvent):void {
		sendNotification(TestMsg.TEST_CANCELED_NOTIFICATION);
	}

	override protected function deactivate():void {
		view.cancelBtn.removeEventListener(MouseEvent.CLICK, onCanceled);
		view.themeColl = null;
	}
}
}