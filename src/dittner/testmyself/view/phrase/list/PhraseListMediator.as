package dittner.testmyself.view.phrase.list {
import dittner.testmyself.command.backend.result.CommandResult;
import dittner.testmyself.message.PhraseMsg;
import dittner.testmyself.model.common.IPageInfo;
import dittner.testmyself.model.phrase.IPhrase;
import dittner.testmyself.view.common.list.SelectableDataGroup;
import dittner.testmyself.view.common.mediator.RequestMediator;
import dittner.testmyself.view.common.mediator.RequestMessage;
import dittner.testmyself.view.common.toobar.ToolAction;
import dittner.testmyself.view.phrase.common.PageLayoutInfo;
import dittner.testmyself.view.phrase.common.PhraseRendererData;

import flash.events.Event;

import mx.collections.ArrayCollection;

public class PhraseListMediator extends RequestMediator {

	[Inject]
	public var view:TransUnitList;

	private var pageLayoutInfo:PageLayoutInfo;

	override protected function onRegister():void {
		pageLayoutInfo = new PageLayoutInfo();
		view.addEventListener(SelectableDataGroup.SELECTED, phraseRenDataSelectedHandler);
		addHandler(PhraseMsg.TOOL_ACTION_SELECTED_NOTIFICATION, toolActionSelectedHandler);
		addHandler(PhraseMsg.PAGE_INFO_CHANGED_NOTIFICATION, onPageInfoChanged);
		sendRequest(PhraseMsg.GET_PAGE_INFO, new RequestMessage(onPageInfoLoaded));
	}

	private function phraseRenDataSelectedHandler(event:Event):void {
		var selectedPhraseRenData:PhraseRendererData = view.selectedItem as PhraseRendererData;
		var selectedPhrase:IPhrase = selectedPhraseRenData ? selectedPhraseRenData.phrase : null;
		sendMessage(PhraseMsg.SELECT_PHRASE, selectedPhrase);
	}

	private function onPageInfoChanged(pageInfo:IPageInfo):void {
		updateViewList(pageInfo);
	}
	private function onPageInfoLoaded(res:CommandResult):void {
		updateViewList(res.data as IPageInfo);
	}

	private function updateViewList(pageInfo:IPageInfo):void {
		view.dataProvider = new ArrayCollection(wrapPhrases(pageInfo.transUnits));
		sendMessage(PhraseMsg.SELECT_PHRASE, null);
	}

	private function wrapPhrases(phrases:Array):Array {
		var items:Array = [];
		var item:PhraseRendererData;
		for each(var vo:IPhrase in phrases) {
			item = new PhraseRendererData(vo, pageLayoutInfo);
			items.push(item);
		}
		return items;
	}

	private function toolActionSelectedHandler(toolId:String):void {
		switch (toolId) {
			case(ToolAction.TRANS_INVERT) :
				pageLayoutInfo.transInverted = !pageLayoutInfo.transInverted;
				break;
			case(ToolAction.HOR_LAYOUT) :
				pageLayoutInfo.isHorizontal = true;
				break;
			case(ToolAction.VER_LAYOUT) :
				pageLayoutInfo.isHorizontal = false;
				break;
			case(ToolAction.HIDE_DETAILS) :
				pageLayoutInfo.showDetails = false;
				break;
			case(ToolAction.SHOW_DETAILS) :
				pageLayoutInfo.showDetails = true;
				break;
		}
		view.invalidateLayout();
	}

	override protected function onRemove():void {
		view.removeEventListener(SelectableDataGroup.SELECTED, phraseRenDataSelectedHandler);
		removeAllHandlers();
		view.dataProvider = null;
		sendMessage(PhraseMsg.SELECT_PHRASE, null);
		pageLayoutInfo = null;
	}

}
}