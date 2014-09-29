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

		addListenerTo(ModuleName.WORD, NoteMsg.NOTES_INFO_CHANGED_NOTIFICATION, wordsInfoChanged);
		sendRequestTo(ModuleName.WORD, NoteMsg.GET_NOTES_INFO, new RequestMessage(wordsInfoLoaded));

		addListenerTo(ModuleName.VERB, NoteMsg.NOTES_INFO_CHANGED_NOTIFICATION, verbsInfoChanged);
		sendRequestTo(ModuleName.VERB, NoteMsg.GET_NOTES_INFO, new RequestMessage(verbsInfoLoaded));

		addListenerTo(ModuleName.LESSON, NoteMsg.NOTES_INFO_CHANGED_NOTIFICATION, lessonInfoChanged);
		sendRequestTo(ModuleName.LESSON, NoteMsg.GET_NOTES_INFO, new RequestMessage(lessonInfoLoaded));
	}

	private function phrasesInfoChanged(info:NotesInfo):void {
		view.infoBoard.phraseInfo = info;
	}
	private function phrasesInfoLoaded(res:CommandResult):void {
		view.infoBoard.phraseInfo = res.data as NotesInfo;
	}

	private function wordsInfoChanged(info:NotesInfo):void {
		view.infoBoard.wordInfo = info;
	}
	private function wordsInfoLoaded(res:CommandResult):void {
		view.infoBoard.wordInfo = res.data as NotesInfo;
	}

	private function verbsInfoChanged(info:NotesInfo):void {
		view.infoBoard.verbInfo = info;
	}
	private function verbsInfoLoaded(res:CommandResult):void {
		view.infoBoard.verbInfo = res.data as NotesInfo;
	}

	private function lessonInfoChanged(info:NotesInfo):void {
		view.infoBoard.lessonInfo = info;
	}
	private function lessonInfoLoaded(res:CommandResult):void {
		view.infoBoard.lessonInfo = res.data as NotesInfo;
		sendRequest(ScreenMsg.UNLOCK, new RequestMessage());
	}

	override protected function deactivate():void {}
}
}