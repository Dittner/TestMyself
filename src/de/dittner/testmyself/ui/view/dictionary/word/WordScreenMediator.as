package de.dittner.testmyself.ui.view.dictionary.word {
import de.dittner.async.IAsyncOperation;
import de.dittner.async.utils.doLaterInMSec;
import de.dittner.satelliteFlight.mediator.SFMediator;
import de.dittner.satelliteFlight.message.RequestMessage;
import de.dittner.testmyself.backend.message.NoteMsg;
import de.dittner.testmyself.model.ModuleName;
import de.dittner.testmyself.ui.message.ScreenMsg;
import de.dittner.testmyself.ui.view.dictionary.note.NoteScreen;
import de.dittner.testmyself.ui.view.dictionary.note.filter.NoteFilterMediator;
import de.dittner.testmyself.ui.view.dictionary.note.form.NoteRemoverMediator;
import de.dittner.testmyself.ui.view.dictionary.note.list.ExampleListMediator;
import de.dittner.testmyself.ui.view.dictionary.note.list.NoteListMediator;
import de.dittner.testmyself.ui.view.dictionary.note.mp3Player.NotePlayerMediator;
import de.dittner.testmyself.ui.view.dictionary.note.pagination.NotePaginationMediator;
import de.dittner.testmyself.ui.view.dictionary.note.search.NoteSearchMediator;
import de.dittner.testmyself.ui.view.dictionary.note.toolbar.NoteToolbarMediator;
import de.dittner.testmyself.ui.view.dictionary.word.form.WordCreatorMediator;
import de.dittner.testmyself.ui.view.dictionary.word.form.WordEditorMediator;

public class WordScreenMediator extends SFMediator {

	public function WordScreenMediator() {}

	[Inject]
	public var view:NoteScreen;

	override protected function activate():void {
		sendRequest(ScreenMsg.LOCK, new RequestMessage());
		doLaterInMSec(preActivation, 500);
	}

	private function preActivation():void {
		sendRequest(NoteMsg.GET_NOTE_PAGE_INFO, new RequestMessage(onPageInfoLoaded));
	}

	private function onPageInfoLoaded(op:IAsyncOperation):void {
		activateScreen();
		sendRequest(ScreenMsg.UNLOCK, new RequestMessage());
	}

	private function activateScreen():void {
		view.activate(ModuleName.WORD);
		addListener(NoteMsg.FORM_ACTIVATED_NOTIFICATION, showEditor);
		addListener(NoteMsg.FORM_DEACTIVATED_NOTIFICATION, hideEditor);
		registerMediator(view.toolbar, new NoteToolbarMediator());
		registerMediator(view.form, new WordCreatorMediator());
		registerMediator(view.form, new WordEditorMediator());
		registerMediator(view.form, new NoteRemoverMediator());
		registerMediator(view.list, new NoteListMediator());
		registerMediator(view.filter, new NoteFilterMediator());
		registerMediator(view.searchFilter, new NoteSearchMediator());
		registerMediator(view.paginationBar, new NotePaginationMediator());
		registerMediator(view.mp3Player, new NotePlayerMediator());
		registerMediator(view.exampleList, new ExampleListMediator());
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