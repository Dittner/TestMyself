package dittner.testmyself.view.phrase.pagination {
import dittner.testmyself.command.operation.result.CommandResult;
import dittner.testmyself.message.PhraseMsg;
import dittner.testmyself.model.common.DataBaseInfo;
import dittner.testmyself.model.phrase.IPhrasePageInfo;
import dittner.testmyself.view.common.mediator.RequestMediator;
import dittner.testmyself.view.common.mediator.RequestMessage;
import dittner.testmyself.view.common.pagination.PaginationBar;

import flash.events.MouseEvent;

public class PhrasePaginationMediator extends RequestMediator {

	[Inject]
	public var view:PaginationBar;

	override protected function onRegister():void {
		addHandler(PhraseMsg.PAGE_INFO_CHANGED_NOTIFICATION, onPageInfoChanged);
		addHandler(PhraseMsg.DB_INFO_CHANGED_NOTIFICATION, phraseDBInfoChanged);
		sendRequest(PhraseMsg.GET_PAGE_INFO, new RequestMessage(onPageInfoLoaded));
		sendRequest(PhraseMsg.GET_DATA_BASE_INFO, new RequestMessage(phraseDBInfoLoaded));
		view.nextPageBtn.addEventListener(MouseEvent.CLICK, nextPageBtnClickHandler);
		view.prevPageBtn.addEventListener(MouseEvent.CLICK, prevPageBtnClickHandler);
		view.firstPageBtn.addEventListener(MouseEvent.CLICK, firstPageBtnClickHandler);
		view.lastPageBtn.addEventListener(MouseEvent.CLICK, lastPageBtnClickHandler);
	}

	private function onPageInfoChanged(pageInfo:IPhrasePageInfo):void {
		updateView(pageInfo);
	}

	private function onPageInfoLoaded(res:CommandResult):void {
		updateView(res.data as IPhrasePageInfo);
	}

	private function updateView(info:IPhrasePageInfo):void {
		view.unitsOnPage = info.phrases.length;
		view.curPageNum = info.pageNum;
		view.pageSize = info.pageSize;
	}

	private function phraseDBInfoChanged(info:DataBaseInfo):void {
		view.unitsTotal = info.filteredUnitsAmount;
	}

	private function phraseDBInfoLoaded(res:CommandResult):void {
		view.unitsTotal = (res.data as DataBaseInfo).filteredUnitsAmount;
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
		loadPageInfo(view.pageTotal - 1);
	}

	private function loadPageInfo(pageNum:uint):void {
		sendMessage(PhraseMsg.GET_PAGE_INFO, new RequestMessage(null, null, pageNum))
	}

	override protected function onRemove():void {
		removeAllHandlers();
		view.nextPageBtn.removeEventListener(MouseEvent.CLICK, nextPageBtnClickHandler);
		view.prevPageBtn.removeEventListener(MouseEvent.CLICK, prevPageBtnClickHandler);
		view.firstPageBtn.removeEventListener(MouseEvent.CLICK, firstPageBtnClickHandler);
		view.lastPageBtn.removeEventListener(MouseEvent.CLICK, lastPageBtnClickHandler);
	}
}
}