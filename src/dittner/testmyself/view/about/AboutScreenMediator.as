package dittner.testmyself.view.about {
import dittner.testmyself.command.operation.result.CommandResult;
import dittner.testmyself.message.PhraseMsg;
import dittner.testmyself.message.ScreenMsg;
import dittner.testmyself.model.common.DataBaseInfo;
import dittner.testmyself.view.common.mediator.RequestMediator;
import dittner.testmyself.view.common.mediator.RequestMessage;

public class AboutScreenMediator extends RequestMediator {

	[Inject]
	public var view:AboutScreen;

	override protected function onRegister():void {
		sendMessage(ScreenMsg.LOCK_UI);
		sendRequest(PhraseMsg.GET_DATA_BASE_INFO, new RequestMessage(phraseDBInfoLoaded));
	}

	private function phraseDBInfoLoaded(res:CommandResult):void {
		view.dataBaseInfoBoard.phraseInfo = res.data as DataBaseInfo;
		sendMessage(ScreenMsg.UNLOCK_UI);
	}

	override protected function onRemove():void {}
}
}