package de.dittner.testmyself.ui.view.search {
import de.dittner.async.IAsyncOperation;
import de.dittner.satelliteFlight.mediator.SFMediator;
import de.dittner.satelliteFlight.message.RequestMessage;
import de.dittner.testmyself.backend.message.NoteMsg;
import de.dittner.testmyself.backend.message.SearchMsg;
import de.dittner.testmyself.model.domain.note.INote;
import de.dittner.testmyself.model.search.FoundNote;
import de.dittner.testmyself.model.settings.SettingsModel;
import de.dittner.testmyself.ui.common.pagination.PaginationBar;

import flash.events.MouseEvent;

public class SearchPaginationMediator extends SFMediator {

	[Inject]
	public var view:PaginationBar;

	[Inject]
	public var settingsModel:SettingsModel;

	private var foundNotes:Array;
	private var loadingNoteQueue:Array = [];
	private var isLoading:Boolean = false;
	private var loadingFoundNote:FoundNote;

	private function get pageSize():uint {return settingsModel.info.pageSize;}

	override protected function activate():void {
		addListener(SearchMsg.FOUND_NOTES_UPDATED_NOTIFICATION, foundNotesUpdated);
		view.nextPageBtn.addEventListener(MouseEvent.CLICK, nextPageBtnClickHandler);
		view.prevPageBtn.addEventListener(MouseEvent.CLICK, prevPageBtnClickHandler);
		view.firstPageBtn.addEventListener(MouseEvent.CLICK, firstPageBtnClickHandler);
		view.lastPageBtn.addEventListener(MouseEvent.CLICK, lastPageBtnClickHandler);
	}

	private function foundNotesUpdated(foundNotes:Array):void {
		this.foundNotes = foundNotes;
		view.notesOnPage = Math.min(pageSize, foundNotes.length);
		view.curPageNum = 0;
		view.pageSize = pageSize;
		view.totalNotes = foundNotes.length;
		loadPageInfo(0);
	}

	private function nextPageBtnClickHandler(event:MouseEvent):void {
		loadPageInfo(view.curPageNum + 1);
	}

	private function prevPageBtnClickHandler(event:MouseEvent):void {
		loadPageInfo(view.curPageNum - 1);
	}

	private function firstPageBtnClickHandler(event:MouseEvent):void {
		loadPageInfo(0);
	}

	private function lastPageBtnClickHandler(event:MouseEvent):void {
		loadPageInfo(view.totalPages - 1);
	}

	private function loadPageInfo(pageNum:uint):void {
		if (isLoading) return;
		view.curPageNum = pageNum;
		isLoading = true;
		loadingNoteQueue.length = 0;
		loadingNoteQueue = [];
		for (var i:uint = pageNum * pageSize; i < foundNotes.length && loadingNoteQueue.length < pageSize; i++)
			loadingNoteQueue.push(foundNotes[i]);
		loadNext();
	}

	private function loadNext():void {
		if (loadingNoteQueue.length > 0) {
			loadingFoundNote = loadingNoteQueue.shift();
			if (loadingFoundNote.note) {
				loadNext();
				return;
			}
			var msg:String = loadingFoundNote.isExample ? NoteMsg.GET_EXAMPLE : NoteMsg.GET_NOTE;
			sendRequestTo(loadingFoundNote.moduleName, msg, new RequestMessage(onNoteLoaded, loadingFoundNote.noteID));
		}
		else {
			isLoading = false;
			var loadedNotes:Array = [];
			for (var i:uint = view.curPageNum * pageSize; i < foundNotes.length && loadedNotes.length < pageSize; i++)
				loadedNotes.push(foundNotes[i]);
			sendNotification(SearchMsg.FOUND_NOTES_LOADED_NOTIFICATION, loadedNotes);
		}
	}

	private function onNoteLoaded(op:IAsyncOperation):void {
		if (op.isSuccess && op.result) {
			loadingFoundNote.note = op.result as INote;
			loadNext();
		}
	}

	override protected function deactivate():void {
		view.notesOnPage = 0;
		view.curPageNum = 0;
		view.pageSize = 0;
		view.totalNotes = 0;
		view.nextPageBtn.removeEventListener(MouseEvent.CLICK, nextPageBtnClickHandler);
		view.prevPageBtn.removeEventListener(MouseEvent.CLICK, prevPageBtnClickHandler);
		view.firstPageBtn.removeEventListener(MouseEvent.CLICK, firstPageBtnClickHandler);
		view.lastPageBtn.removeEventListener(MouseEvent.CLICK, lastPageBtnClickHandler);
	}
}
}