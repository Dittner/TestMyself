package dittner.testmyself.deutsch.view.about {
import dittner.satelliteFlight.command.CommandResult;
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.core.model.note.NotesInfo;
import dittner.testmyself.deutsch.message.ScreenMsg;
import dittner.testmyself.deutsch.model.ModuleName;

public class AboutScreenMediator extends SFMediator {

	[Inject]
	public var view:AboutScreen;

	override protected function activate():void {
		sendRequest(ScreenMsg.LOCK, new RequestMessage());
		addListenerTo(ModuleName.PHRASE, NoteMsg.NOTES_INFO_CHANGED_NOTIFICATION, phrasesInfoChanged);
		sendRequestTo(ModuleName.PHRASE, NoteMsg.GET_NOTES_INFO, new RequestMessage(phrasesInfoLoaded));
	}

	private function phrasesInfoChanged(info:NotesInfo):void {
		view.infoBoard.phraseInfo = info;
	}

	private function phrasesInfoLoaded(res:CommandResult):void {
		view.infoBoard.phraseInfo = res.data as NotesInfo;
		sendRequest(ScreenMsg.UNLOCK, new RequestMessage());
	}

	override protected function deactivate():void {}
}
}