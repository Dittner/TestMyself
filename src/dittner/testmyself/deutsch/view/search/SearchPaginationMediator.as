package dittner.testmyself.deutsch.view.search {
import dittner.async.IAsyncOperation;
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.core.message.SearchMsg;
import dittner.testmyself.core.model.note.INote;
import dittner.testmyself.deutsch.model.search.FoundNote;
import dittner.testmyself.deutsch.view.common.pagination.PaginationBar;

import flash.events.MouseEvent;

public class SearchPaginationMediator extends SFMediator {

	[Inject]
	public var view:PaginationBar;

	private const PAGE_SIZE:uint = 20;
	private var foundNotes:Array;
	private var loadingNoteQueue:Array = [];
	private var isLoading:Boolean = false;
	private var loadingFoundNote:FoundNote;

	override protected function activate():void {
		addListener(SearchMsg.FOUND_NOTES_UPDATED_NOTIFICATION, foundNotesUpdated);
		view.nextPageBtn.addEventListener(MouseEvent.CLICK, nextPageBtnClickHandler);
		view.prevPageBtn.addEventListener(MouseEvent.CLICK, prevPageBtnClickHandler);
		view.firstPageBtn.addEventListener(MouseEvent.CLICK, firstPageBtnClickHandler);
		view.lastPageBtn.addEventListener(MouseEvent.CLICK, lastPageBtnClickHandler);
	}

	private function foundNotesUpdated(foundNotes:Array):void {
		this.foundNotes = foundNotes;
		view.notesOnPage = Math.min(PAGE_SIZE, foundNotes.length);
		view.curPageNum = 0;
		view.pageSize = PAGE_SIZE;
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
		for (var i:uint = pageNum * PAGE_SIZE; i < foundNotes.length && loadingNoteQueue.length < PAGE_SIZE; i++)
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
			for (var i:uint = view.curPageNum * PAGE_SIZE; i < foundNotes.length && loadedNotes.length < PAGE_SIZE; i++)
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