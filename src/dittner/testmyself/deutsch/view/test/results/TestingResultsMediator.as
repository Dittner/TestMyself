package dittner.testmyself.deutsch.view.test.results {
import dittner.satelliteFlight.command.CommandResult;
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.core.message.TestMsg;
import dittner.testmyself.core.model.page.ITestPageInfo;
import dittner.testmyself.core.model.test.TestInfo;
import dittner.testmyself.deutsch.view.common.pagination.PaginationBar;

import flash.events.MouseEvent;

public class TestingResultsMediator extends SFMediator {

	[Inject]
	public var view:TestingResultsView;
	private var selectedTestInfo:TestInfo;

	public function TestingResultsMediator(testInfo:TestInfo):void {
		super();
		selectedTestInfo = testInfo;
	}

	private function get paginationBar():PaginationBar {
		return view.paginationBar;
	}

	override protected function activate():void {
		view.goBackBtn.addEventListener(MouseEvent.CLICK, goBackClickHandler);
		//sendRequestTo(selectedTestInfo.moduleName, TestMsg.GET_TEST_PAGE_INFO, new RequestMessage(onPageInfoLoaded));
		paginationBar.nextPageBtn.addEventListener(MouseEvent.CLICK, nextPageBtnClickHandler);
		paginationBar.prevPageBtn.addEventListener(MouseEvent.CLICK, prevPageBtnClickHandler);
		paginationBar.firstPageBtn.addEventListener(MouseEvent.CLICK, firstPageBtnClickHandler);
		paginationBar.lastPageBtn.addEventListener(MouseEvent.CLICK, lastPageBtnClickHandler);
	}

	private function onPageInfoLoaded(res:CommandResult):void {
		updateView(res.data as ITestPageInfo);
	}

	private function updateView(info:ITestPageInfo):void {
		paginationBar.notesOnPage = info.notes.length;
		paginationBar.curPageNum = info.pageNum;
		paginationBar.pageSize = info.pageSize;
	}

	private function nextPageBtnClickHandler(event:MouseEvent):void {
		loadPageInfo(paginationBar.curPageNum + 1);
	}

	private function prevPageBtnClickHandler(event:MouseEvent):void {
		loadPageInfo(paginationBar.curPageNum - 1);
	}

	private function firstPageBtnClickHandler(event:MouseEvent):void {
		loadPageInfo(0);
	}

	private function lastPageBtnClickHandler(event:MouseEvent):void {
		loadPageInfo(paginationBar.totalPages - 1);
	}

	private function loadPageInfo(pageNum:uint):void {
		sendRequestTo(selectedTestInfo.moduleName, TestMsg.GET_TEST_PAGE_INFO, new RequestMessage(null, null, pageNum))
	}

	private function goBackClickHandler(event:MouseEvent):void {
		sendNotification(TestMsg.SHOW_TEST_PRESETS_NOTIFICATION);
	}

	override protected function deactivate():void {
		view.goBackBtn.removeEventListener(MouseEvent.CLICK, goBackClickHandler);
		paginationBar.nextPageBtn.removeEventListener(MouseEvent.CLICK, nextPageBtnClickHandler);
		paginationBar.prevPageBtn.removeEventListener(MouseEvent.CLICK, prevPageBtnClickHandler);
		paginationBar.firstPageBtn.removeEventListener(MouseEvent.CLICK, firstPageBtnClickHandler);
		paginationBar.lastPageBtn.removeEventListener(MouseEvent.CLICK, lastPageBtnClickHandler);
	}

}
}