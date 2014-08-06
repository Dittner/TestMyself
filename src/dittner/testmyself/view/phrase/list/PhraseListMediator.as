package dittner.testmyself.view.phrase.list {
import dittner.testmyself.message.PhraseMsg;
import dittner.testmyself.model.phrase.PhraseVo;
import dittner.testmyself.view.common.SelectableDataGroup;
import dittner.testmyself.view.common.mediator.RequestMessage;
import dittner.testmyself.view.common.mediator.SmartMediator;
import dittner.testmyself.view.common.mediator.mediator_internal;
import dittner.testmyself.view.common.toobar.ToolAction;
import dittner.testmyself.view.phrase.common.PhraseRendererData;

import flash.events.Event;

import mx.collections.ArrayCollection;

use namespace mediator_internal;

public class PhraseListMediator extends SmartMediator {

	[Inject]
	public var view:LanguageUnitList;

	private var wrappedPhrases:Array = [];

	override protected function onRegister():void {
		view.addEventListener(SelectableDataGroup.SELECTED, phraseRenDataSelectedHandler);
		addHandler(PhraseMsg.TOOL_ACTION_SELECTED_NOTIFICATION, toolActionSelectedHandler);
		sendRequest(PhraseMsg.GET_PHRASES, new RequestMessage(onPhrasesLoaded));
	}

	private function phraseRenDataSelectedHandler(event:Event):void {
		var selectedPhraseRenData:PhraseRendererData = view.selectedItem as PhraseRendererData;
		var selectedPhrase:PhraseVo = selectedPhraseRenData ? selectedPhraseRenData.phrase : PhraseVo.NULL;
		sendMessage(PhraseMsg.SELECT_PHRASE, selectedPhrase);
	}

	private function onPhrasesLoaded(phrases:Array):void {
		wrappedPhrases = wrapPhrases(phrases);
		view.dataProvider = new ArrayCollection(wrappedPhrases);
	}

	private function wrapPhrases(phrases:Array):Array {
		var items:Array = [];
		var item:PhraseRendererData;
		for each(var vo:PhraseVo in phrases) {
			item = new PhraseRendererData(vo);
			items.push(item);
		}
		return items;
	}

	private function toolActionSelectedHandler(toolId:String):void {
		var item:PhraseRendererData;
		switch (toolId) {
			case(ToolAction.TRANS_INVERT) :
				for each(item in wrappedPhrases) item.transInverted = !item.transInverted;
				break;
			case(ToolAction.HOR_LAYOUT) :
				for each(item in wrappedPhrases) item.horizontalLayout = true;
				break;
			case(ToolAction.VER_LAYOUT) :
				for each(item in wrappedPhrases) item.horizontalLayout = false;
				break;
			case(ToolAction.HIDE_DETAILS) :
				for each(item in wrappedPhrases) item.showDetails = false;
				break;
			case(ToolAction.SHOW_DETAILS) :
				for each(item in wrappedPhrases) item.showDetails = true;
				break;
		}
	}

	override protected function onRemove():void {
		view.removeEventListener(SelectableDataGroup.SELECTED, phraseRenDataSelectedHandler);
		removeAllHandlers();
		view.dataProvider = null;
	}

}
}