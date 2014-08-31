package dittner.testmyself.deutsch.view.note {
import dittner.satelliteFlight.command.CommandResult;
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.deutsch.message.ScreenMsg;
import dittner.testmyself.deutsch.utils.pendingInvoke.doLaterInFrames;
import dittner.testmyself.deutsch.view.note.filter.NoteFilterMediator;
import dittner.testmyself.deutsch.view.note.form.NoteCreatorMediator;
import dittner.testmyself.deutsch.view.note.form.NoteEditorMediator;
import dittner.testmyself.deutsch.view.note.form.NoteRemoverMediator;
import dittner.testmyself.deutsch.view.note.list.NoteListMediator;
import dittner.testmyself.deutsch.view.note.mp3Player.NotePlayerMediator;
import dittner.testmyself.deutsch.view.note.pagination.NotePaginationMediator;
import dittner.testmyself.deutsch.view.note.toolbar.NoteToolbarMediator;

public class NoteScreenMediator extends SFMediator {

	[Inject]
	public var view:NoteScreen;

	override protected function activate():void {
		sendRequest(ScreenMsg.LOCK, new RequestMessage());
		doLaterInFrames(preActivation, 5);
	}

	private function preActivation():void {
		sendRequest(NoteMsg.GET_PAGE_INFO, new RequestMessage(onPageInfoLoaded));
	}

	private function onPageInfoLoaded(res:CommandResult):void {
		activateScreen()
	}

	private function activateScreen():void {
		view.activate();
		addListener(NoteMsg.FORM_ACTIVATED_NOTIFICATION, showEditor);
		addListener(NoteMsg.FORM_DEACTIVATED_NOTIFICATION, hideEditor);
		registerMediator(view.toolbar, new NoteToolbarMediator());
		registerMediator(view.form, new NoteCreatorMediator());
		registerMediator(view.form, new NoteEditorMediator());
		registerMediator(view.form, new NoteRemoverMediator());
		registerMediator(view.list, new NoteListMediator());
		registerMediator(view.filter, new NoteFilterMediator());
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