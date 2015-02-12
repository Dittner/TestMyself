package dittner.testmyself.deutsch.view.search {
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.deutsch.message.ScreenMsg;
import dittner.testmyself.deutsch.utils.pendingInvoke.doLaterInFrames;
import dittner.testmyself.deutsch.view.dictionary.note.mp3Player.NotePlayerMediator;

public class SearchScreenMediator extends SFMediator {

	public function SearchScreenMediator() {}

	[Inject]
	public var view:SearchScreen;

	override protected function activate():void {
		sendRequest(ScreenMsg.LOCK, new RequestMessage());
		doLaterInFrames(preActivation, 5);
	}

	private function preActivation():void {
		activateScreen();
	}

	private function activateScreen():void {
		view.activate();
		addListener(NoteMsg.FORM_ACTIVATED_NOTIFICATION, showEditor);
		addListener(NoteMsg.FORM_DEACTIVATED_NOTIFICATION, hideEditor);
		//registerMediator(view.form, new WordEditorMediator());
		registerMediator(view.list, new SearchResultListMediator());
		registerMediator(view.searchBoard, new SearchBoardMediator());
		registerMediator(view.paginationBar, new SearchPaginationMediator());
		registerMediator(view.mp3Player, new NotePlayerMediator());
		registerMediator(view.exampleList, new FoundNotesExampleListMediator());
		sendRequest(ScreenMsg.UNLOCK, new RequestMessage());
	}

	private function showEditor(params:* = null):void {
		view.showEditor();
	}

	private function hideEditor(params:* = null):void {
		view.hideEditor();
	}

	override protected function deactivate():void {
		view.deactivate();
	}

}
}