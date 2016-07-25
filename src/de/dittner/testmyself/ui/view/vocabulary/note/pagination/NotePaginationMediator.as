package de.dittner.testmyself.ui.view.vocabulary.note.pagination {
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.message.NoteMsg;
import de.dittner.testmyself.model.domain.vocabulary.VocabularyInfo;
import de.dittner.testmyself.model.page.INotePageRequest;
import de.dittner.testmyself.ui.common.pagination.PaginationBar;

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

	private function onPageInfoChanged(pageInfo:INotePageRequest):void {
		updateView(pageInfo);
	}

	private function onPageInfoLoaded(op:IAsyncOperation):void {
		updateView(op.result as INotePageRequest);
	}

	private function updateView(info:INotePageRequest):void {
		view.notesOnPage = info.notes.length;
		view.curPageNum = info.pageNum;
		view.pageSize = info.pageSize;
	}

	private function notesInfoChanged(info:VocabularyInfo):void {
		view.totalNotes = info.filteredNotesAmount;
	}

	private function notesInfoLoaded(op:IAsyncOperation):void {
		view.totalNotes = (op.result as VocabularyInfo).filteredNotesAmount;
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