package de.dittner.testmyself.ui.view.vocabulary.verb {
import de.dittner.async.IAsyncOperation;
import de.dittner.async.utils.doLaterInMSec;
import de.dittner.testmyself.backend.message.NoteMsg;
import de.dittner.testmyself.ui.message.ScreenMsg;
import de.dittner.testmyself.ui.view.vocabulary.note.filter.NoteFilterMediator;
import de.dittner.testmyself.ui.view.vocabulary.note.form.NoteRemoverMediator;
import de.dittner.testmyself.ui.view.vocabulary.note.list.ExampleListMediator;
import de.dittner.testmyself.ui.view.vocabulary.note.list.NoteListMediator;
import de.dittner.testmyself.ui.view.vocabulary.note.mp3Player.NotePlayerMediator;
import de.dittner.testmyself.ui.view.vocabulary.note.pagination.NotePaginationMediator;
import de.dittner.testmyself.ui.view.vocabulary.note.search.NoteSearchMediator;
import de.dittner.testmyself.ui.view.vocabulary.note.toolbar.NoteToolbarMediator;
import de.dittner.testmyself.ui.view.vocabulary.verb.form.VerbCreatorMediator;
import de.dittner.testmyself.ui.view.vocabulary.verb.form.VerbEditorMediator;
import de.dittner.testmyself.ui.view.wordList.NoteListView;

public class VerbScreenMediator extends SFMediator {

	public function VerbScreenMediator() {}

	[Inject]
	public var view:NoteListView;

	override protected function activate():void {
		sendRequest(ScreenMsg.LOCK, new RequestMessage());
		doLaterInMSec(preActivation, 500);
	}

	private function preActivation():void {
		sendRequest(NoteMsg.GET_NOTE_PAGE_INFO, new RequestMessage(onPageInfoLoaded));
	}

	private function onPageInfoLoaded(op:IAsyncOperation):void {
		activateScreen()
	}

	private function activateScreen():void {
		view.activate(ModuleName.VERB);
		addListener(NoteMsg.FORM_ACTIVATED_NOTIFICATION, showEditor);
		addListener(NoteMsg.FORM_DEACTIVATED_NOTIFICATION, hideEditor);
		registerMediator(view.toolbar, new NoteToolbarMediator());
		registerMediator(view.form, new VerbCreatorMediator());
		registerMediator(view.form, new VerbEditorMediator());
		registerMediator(view.form, new NoteRemoverMediator());
		registerMediator(view.list, new NoteListMediator());
		registerMediator(view.filter, new NoteFilterMediator());
		registerMediator(view.searchFilter, new NoteSearchMediator());
		registerMediator(view.paginationBar, new NotePaginationMediator());
		registerMediator(view.mp3Player, new NotePlayerMediator());
		registerMediator(view.exampleList, new ExampleListMediator());
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