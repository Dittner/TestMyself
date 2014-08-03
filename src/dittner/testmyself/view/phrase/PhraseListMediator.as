package dittner.testmyself.view.phrase {
import dittner.testmyself.message.PhraseMsg;
import dittner.testmyself.model.phrase.PhraseVo;
import dittner.testmyself.service.helpers.toolFactory.Tool;
import dittner.testmyself.service.helpers.toolFactory.ToolId;
import dittner.testmyself.view.common.SelectableDataGroup;
import dittner.testmyself.view.common.mediator.RequestOperationMessage;
import dittner.testmyself.view.common.mediator.SmartMediator;
import dittner.testmyself.view.common.mediator.mediator_internal;
import dittner.testmyself.view.phrase.components.LanguageUnitList;
import dittner.testmyself.view.phrase.components.PhraseRendererData;

import flash.events.Event;

import mx.collections.ArrayCollection;

use namespace mediator_internal;

public class PhraseListMediator extends SmartMediator {

	[Inject]
	public var view:LanguageUnitList;

	private var wrappedPhrases:Array = [];

	override protected function onRegister():void {
		view.addEventListener(SelectableDataGroup.SELECTED, phraseRenDataSelectedHandler);
		addHandler(PhraseMsg.TOOL_SELECTED_NOTIFICATION, toolSelectedHandler);
		requestData(PhraseMsg.GET_PHRASES, new RequestOperationMessage(onPhrasesLoaded));
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

	private function toolSelectedHandler(tool:Tool):void {
		switch (tool.id) {
			case(ToolId.TRANS_INVERSION) :
				for each(var item:PhraseRendererData in wrappedPhrases) {
					item.transInverted = !item.transInverted;
				}
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