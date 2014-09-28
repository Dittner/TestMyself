package dittner.testmyself.deutsch.view.note.lesson {
import dittner.satelliteFlight.command.CommandResult;
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.deutsch.message.ScreenMsg;
import dittner.testmyself.deutsch.view.note.form.NoteRemoverMediator;
import dittner.testmyself.deutsch.view.note.lesson.form.LessonCreatorMediator;
import dittner.testmyself.deutsch.view.note.lesson.form.LessonEditorMediator;
import dittner.testmyself.deutsch.view.note.list.NoteListMediator;
import dittner.testmyself.deutsch.view.note.mp3Player.NotePlayerMediator;
import dittner.testmyself.deutsch.view.note.pagination.NotePaginationMediator;
import dittner.testmyself.deutsch.view.note.toolbar.NoteToolbarMediator;

public class LessonContentMediator extends SFMediator {

	[Inject]
	public var view:LessonScreen;

	override protected function activate():void {
		sendRequest(NoteMsg.GET_NOTE_PAGE_INFO, new RequestMessage(onPageInfoLoaded));
	}

	private function onPageInfoLoaded(res:CommandResult):void {
		activateScreen()
	}

	private function activateScreen():void {
		addListener(NoteMsg.FORM_ACTIVATED_NOTIFICATION, showEditor);
		addListener(NoteMsg.FORM_DEACTIVATED_NOTIFICATION, hideEditor);
		registerMediator(view.toolbar, new NoteToolbarMediator());
		registerMediator(view.form, new LessonCreatorMediator());
		registerMediator(view.form, new LessonEditorMediator());
		registerMediator(view.form, new NoteRemoverMediator());
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