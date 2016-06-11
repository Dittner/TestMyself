package dittner.testmyself.deutsch.view.dictionary.verb {
import de.dittner.async.IAsyncOperation;
import de.dittner.async.utils.doLaterInMSec;

import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.deutsch.message.ScreenMsg;
import dittner.testmyself.deutsch.model.ModuleName;
import dittner.testmyself.deutsch.view.dictionary.note.NoteScreen;
import dittner.testmyself.deutsch.view.dictionary.note.filter.NoteFilterMediator;
import dittner.testmyself.deutsch.view.dictionary.note.form.NoteRemoverMediator;
import dittner.testmyself.deutsch.view.dictionary.note.list.ExampleListMediator;
import dittner.testmyself.deutsch.view.dictionary.note.list.NoteListMediator;
import dittner.testmyself.deutsch.view.dictionary.note.mp3Player.NotePlayerMediator;
import dittner.testmyself.deutsch.view.dictionary.note.pagination.NotePaginationMediator;
import dittner.testmyself.deutsch.view.dictionary.note.search.NoteSearchMediator;
import dittner.testmyself.deutsch.view.dictionary.note.toolbar.NoteToolbarMediator;
import dittner.testmyself.deutsch.view.dictionary.verb.form.VerbCreatorMediator;
import dittner.testmyself.deutsch.view.dictionary.verb.form.VerbEditorMediator;

public class VerbScreenMediator extends SFMediator {

	public function VerbScreenMediator() {}

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