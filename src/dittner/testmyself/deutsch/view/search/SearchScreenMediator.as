package dittner.testmyself.deutsch.view.search {
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.core.message.SearchMsg;
import dittner.testmyself.deutsch.message.ScreenMsg;
import dittner.testmyself.deutsch.model.search.FoundNote;
import dittner.testmyself.deutsch.utils.pendingInvoke.doLaterInFrames;
import dittner.testmyself.deutsch.view.dictionary.note.mp3Player.NotePlayerMediator;

import flash.events.MouseEvent;

public class SearchScreenMediator extends SFMediator {

	public function SearchScreenMediator() {}

	[Inject]
	public var view:SearchScreen;
	private var noteFormMediator:SearchNoteFormMediator;
	private var searchBoardMediator:SearchBoardMediator;

	override protected function activate():void {
		sendRequest(ScreenMsg.LOCK, new RequestMessage());
		doLaterInFrames(preActivation, 5);
	}

	private function preActivation():void {
		activateScreen();
	}

	private function activateScreen():void {
		view.activate();
		addListener(SearchMsg.HIDE_NOTE_FORM, editingComplete);
		addListener(NoteMsg.FORM_ACTIVATED_NOTIFICATION, showEditor);
		addListener(NoteMsg.FORM_DEACTIVATED_NOTIFICATION, hideEditor);

		searchBoardMediator = new SearchBoardMediator();
		registerMediator(view.list, new SearchResultListMediator());
		registerMediator(view.searchBoard, searchBoardMediator);
		registerMediator(view.paginationBar, new SearchPaginationMediator());
		registerMediator(view.mp3Player, new NotePlayerMediator());
		registerMediator(view.exampleList, new FoundNotesExampleListMediator());
		sendRequest(ScreenMsg.UNLOCK, new RequestMessage());
		view.editBtn.addEventListener(MouseEvent.CLICK, editNote);
		view.removeBtn.addEventListener(MouseEvent.CLICK, removeNote);
	}

	private function editingComplete(params:* = null):void {
		hideEditor();
		searchBoardMediator.startSearch();
	}

	private function editNote(event:MouseEvent):void {
		var selectedFoundNote:FoundNote = view.list.selectedItem as FoundNote;
		if (!noteFormMediator && selectedFoundNote) {
			noteFormMediator = new SearchNoteFormMediator();
			registerMediatorTo(selectedFoundNote.moduleName, view.editForm, noteFormMediator);
			noteFormMediator.startEditing(selectedFoundNote);
			showEditor();
		}
	}

	private function removeNote(event:MouseEvent):void {
		var selectedFoundNote:FoundNote = view.list.selectedItem as FoundNote;
		if (!noteFormMediator && selectedFoundNote) {
			noteFormMediator = new SearchNoteFormMediator();
			registerMediatorTo(selectedFoundNote.moduleName, view.editForm, noteFormMediator);
			noteFormMediator.startRemoving(selectedFoundNote);
			showEditor();
		}
	}

	private function showEditor(params:* = null):void {
		view.showEditor();
	}

	private function hideEditor(params:* = null):void {
		view.hideEditor();
		if (noteFormMediator) {
			unregisterMediatorFrom(noteFormMediator.moduleName, noteFormMediator);
			noteFormMediator = null;
		}
	}

	override protected function deactivate():void {
		view.deactivate();
		view.editBtn.removeEventListener(MouseEvent.CLICK, editNote);
		view.removeBtn.removeEventListener(MouseEvent.CLICK, removeNote);
	}

}
}