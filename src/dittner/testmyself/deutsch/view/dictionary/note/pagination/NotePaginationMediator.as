package dittner.testmyself.deutsch.view.dictionary.note.pagination {
import de.dittner.async.IAsyncOperation;

import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.core.model.note.NotesInfo;
import dittner.testmyself.core.model.page.INotePageInfo;
import dittner.testmyself.deutsch.view.common.pagination.PaginationBar;

import flash.events.MouseEvent;

public class NotePaginationMediator extends SFMediator {

	[Inject]
	public var view:PaginationBar;

	override protected function activate():void {
		addListener(NoteMsg.NOTE_PAGE_INFO_CHANGED_NOTIFICATION, onPageInfoChanged);
		addListener(NoteMsg.NOTES_INFO_CHANGED_NOTIFICATION, notesInfoChanged);
		sendRequest(NoteMsg.GET_NOTE_PAGE_INFO, new RequestMessage(onPageInfoLoaded));
		sendRequest(NoteMsg.GET_NOTES_INFO, new RequestMessage(notesInfoLoaded));
		view.nextPageBtn.addEventListener(MouseEvent.CLICK, nextPageBtnClickHandler);
		view.prevPageBtn.addEventListener(MouseEvent.CLICK, prevPageBtnClickHandler);
		view.firstPageBtn.addEventListener(MouseEvent.CLICK, firstPageBtnClickHandler);
		view.lastPageBtn.addEventListener(MouseEvent.CLICK, lastPageBtnClickHandler);
	}

	private function onPageInfoChanged(pageInfo:INotePageInfo):void {
		updateView(pageInfo);
	}

	private function onPageInfoLoaded(op:IAsyncOperation):void {
		updateView(op.result as INotePageInfo);
	}

	private function updateView(info:INotePageInfo):void {
		view.notesOnPage = info.notes.length;
		view.curPageNum = info.pageNum;
		view.pageSize = info.pageSize;
	}

	private function notesInfoChanged(info:NotesInfo):void {
		view.totalNotes = info.filteredNotesAmount;
	}

	private function notesInfoLoaded(op:IAsyncOperation):void {
		view.totalNotes = (op.result as NotesInfo).filteredNotesAmount;
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
		sendRequest(NoteMsg.GET_NOTE_PAGE_INFO, new RequestMessage(null, pageNum))
	}

	override protected function deactivate():void {
		view.nextPageBtn.removeEventListener(MouseEvent.CLICK, nextPageBtnClickHandler);
		view.prevPageBtn.removeEventListener(MouseEvent.CLICK, prevPageBtnClickHandler);
		view.firstPageBtn.removeEventListener(MouseEvent.CLICK, firstPageBtnClickHandler);
		view.lastPageBtn.removeEventListener(MouseEvent.CLICK, lastPageBtnClickHandler);
	}
}
}