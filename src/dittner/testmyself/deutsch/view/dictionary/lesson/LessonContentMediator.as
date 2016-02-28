package dittner.testmyself.deutsch.view.dictionary.lesson {
import dittner.async.IAsyncOperation;
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.deutsch.message.ScreenMsg;
import dittner.testmyself.deutsch.view.dictionary.lesson.form.LessonCreatorMediator;
import dittner.testmyself.deutsch.view.dictionary.lesson.form.LessonEditorMediator;
import dittner.testmyself.deutsch.view.dictionary.note.form.NoteRemoverMediator;
import dittner.testmyself.deutsch.view.dictionary.note.list.NoteListMediator;
import dittner.testmyself.deutsch.view.dictionary.note.mp3Player.NotePlayerMediator;
import dittner.testmyself.deutsch.view.dictionary.note.pagination.NotePaginationMediator;
import dittner.testmyself.deutsch.view.dictionary.note.search.NoteSearchMediator;
import dittner.testmyself.deutsch.view.dictionary.note.toolbar.NoteToolbarMediator;

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