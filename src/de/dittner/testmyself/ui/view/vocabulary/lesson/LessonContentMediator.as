package de.dittner.testmyself.ui.view.vocabulary.lesson {
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.message.NoteMsg;
import de.dittner.testmyself.ui.message.ScreenMsg;
import de.dittner.testmyself.ui.view.vocabulary.lesson.form.LessonCreatorMediator;
import de.dittner.testmyself.ui.view.vocabulary.lesson.form.LessonEditorMediator;
import de.dittner.testmyself.ui.view.vocabulary.note.form.NoteRemoverMediator;
import de.dittner.testmyself.ui.view.vocabulary.note.list.NoteListMediator;
import de.dittner.testmyself.ui.view.vocabulary.note.mp3Player.NotePlayerMediator;
import de.dittner.testmyself.ui.view.vocabulary.note.pagination.NotePaginationMediator;
import de.dittner.testmyself.ui.view.vocabulary.note.search.NoteSearchMediator;
import de.dittner.testmyself.ui.view.vocabulary.note.toolbar.NoteToolbarMediator;

public class LessonContentMediator extends SFMediator {

	[Inject]
	public var view:LessonScreen;

	override protected function activate():void {
		sendRequest(NoteMsg.GET_NOTE_PAGE_INFO, new RequestMessage(onPageInfoLoaded));
	}

	private function onPageInfoLoaded(op:IAsyncOperation):void {
		activateScreen()
	}

	private function activateScreen():void {
		addListener(NoteMsg.FORM_ACTIVATED_NOTIFICATION, showEditor);
		addListener(NoteMsg.FORM_DEACTIVATED_NOTIFICATION, hideEditor);
		registerMediator(view.toolbar, new NoteToolbarMediator());
		registerMediator(view.form, new LessonCreatorMediator());
		registerMediator(view.form, new LessonEditorMediator());
		registerMediator(view.form, new NoteRemoverMediator());
		registerMediator(view.searchFilter, new NoteSearchMediator());
		registerMediator(view.noteList, new NoteListMediator());
		registerMediator(view.paginationBar, new NotePaginationMediator());
		registerMediator(view.mp3Player, new NotePlayerMediator());
		sendRequest(ScreenMsg.UNLOCK, new RequestMessage());
	}

	private function showEditor(params:* = null):void {
		view.showEditor();
	}

	private function hideEditor(params:* = null):void {
		view.hideEditor();
	}

	override protected function deactivate():void {}

}
}