package dittner.testmyself.deutsch.view.note.pagination {
import dittner.satelliteFlight.command.CommandResult;
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.core.model.note.NotesInfo;
import dittner.testmyself.core.model.page.IPageInfo;
import dittner.testmyself.deutsch.view.common.pagination.PaginationBar;

import flash.events.MouseEvent;

public class NotePaginationMediator extends SFMediator {

	[Inject]
	public var view:PaginationBar;

	override protected function activate():void {
		addListener(NoteMsg.PAGE_INFO_CHANGED_NOTIFICATION, onPageInfoChanged);
		addListener(NoteMsg.NOTES_INFO_CHANGED_NOTIFICATION, notesInfoChanged);
		sendRequest(NoteMsg.GET_PAGE_INFO, new RequestMessage(onPageInfoLoaded));
		sendRequest(NoteMsg.GET_NOTES_INFO, new RequestMessage(notesInfoLoaded));
		view.nextPageBtn.addEventListener(MouseEvent.CLICK, nextPageBtnClickHandler);
		view.prevPageBtn.addEventListener(MouseEvent.CLICK, prevPageBtnClickHandler);
		view.firstPageBtn.addEventListener(MouseEvent.CLICK, firstPageBtnClickHandler);
		view.lastPageBtn.addEventListener(MouseEvent.CLICK, lastPageBtnClickHandler);
	}

	private function onPageInfoChanged(pageInfo:IPageInfo):void {
		updateView(pageInfo);
	}

	private function onPageInfoLoaded(res:CommandResult):void {
		updateView(res.data as IPageInfo);
	}

	private function updateView(info:IPageInfo):void {
		view.notesOnPage = info.notes.length;
		view.curPageNum = info.pageNum;
		view.pageSize = info.pageSize;
	}

	private function notesInfoChanged(info:NotesInfo):void {
		view.totalNotes = info.filteredNotesAmount;
	}

	private function notesInfoLoaded(res:CommandResult):void {
		view.totalNotes = (res.data as NotesInfo).filteredNotesAmount;
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
		sendRequest(NoteMsg.GET_PAGE_INFO, new RequestMessage(null, null, pageNum))
	}

	override protected function deactivate():void {
		view.nextPageBtn.removeEventListener(MouseEvent.CLICK, nextPageBtnClickHandler);
		view.prevPageBtn.removeEventListener(MouseEvent.CLICK, prevPageBtnClickHandler);
		view.firstPageBtn.removeEventListener(MouseEvent.CLICK, firstPageBtnClickHandler);
		view.lastPageBtn.removeEventListener(MouseEvent.CLICK, lastPageBtnClickHandler);
	}
}
}