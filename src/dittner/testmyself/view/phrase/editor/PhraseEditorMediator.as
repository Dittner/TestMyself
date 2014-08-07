package dittner.testmyself.view.phrase.editor {
import dittner.testmyself.message.PhraseMsg;
import dittner.testmyself.model.phrase.PhraseSuite;
import dittner.testmyself.model.phrase.Phrase;
import dittner.testmyself.model.theme.Theme;
import dittner.testmyself.view.common.mediator.RequestMessage;
import dittner.testmyself.view.common.mediator.SmartMediator;
import dittner.testmyself.view.common.toobar.ToolAction;
import dittner.testmyself.view.common.toobar.ToolActionName;
import dittner.testmyself.view.phrase.common.ThemeRendererData;

import flash.events.MouseEvent;

import mx.collections.ArrayCollection;

public class PhraseEditorMediator extends SmartMediator {

	[Inject]
	public var view:PhraseEditor;

	private var selectedPhrase:Phrase = Phrase.NULL;
	private var selectedToolAction:String = "";

	override protected function onRegister():void {
		view.cancelBtn.addEventListener(MouseEvent.CLICK, cancelHandler);
		view.applyBtn.addEventListener(MouseEvent.CLICK, applyHandler);
		addHandler(PhraseMsg.TOOL_ACTION_SELECTED_NOTIFICATION, toolActionSelectedHandler);
		addHandler(PhraseMsg.PHRASE_SELECTED_NOTIFICATION, phraseSelectedHandler);
		sendRequest(PhraseMsg.GET_THEMES, new RequestMessage(onThemesLoaded));
	}

	private function onThemesLoaded(themes:Array):void {
		var themeItems:Array = wrapThemes(themes);
		view.themes = new ArrayCollection(themeItems);
	}

	private function wrapThemes(themes:Array):Array {
		var items:Array = [];
		var item:ThemeRendererData;
		for each(var vo:Theme in themes) {
			item = new ThemeRendererData(vo);
			items.push(item);
		}
		return items;
	}

	private function toolActionSelectedHandler(toolAction:String):void {
		selectedToolAction = toolAction;
		switch (toolAction) {
			case(ToolAction.ADD) :
				view.add();
				open();
				break;
			case(ToolAction.EDIT) :
				view.edit(selectedPhrase);
				open();
				break;
			case(ToolAction.REMOVE) :
				view.remove(selectedPhrase);
				open();
				break;
			default :
				close();
				break;
		}
	}

	private function open():void {
		view.title = ToolActionName.getNameById(selectedToolAction);
		sendMessage(PhraseMsg.EDITOR_ACTIVATED_NOTIFICATION);
	}

	private function close():void {
		view.close();
		sendMessage(PhraseMsg.EDITOR_DEACTIVATED_NOTIFICATION);
	}

	private function phraseSelectedHandler(vo:Phrase):void {
		selectedPhrase = vo;
		if (view.isOpen()) throw new Error("Should not select new phrase when the old one is editing!")
	}

	private function cancelHandler(event:MouseEvent):void {
		close();
	}

	private function applyHandler(event:MouseEvent):void {
		switch (selectedToolAction) {
			case(ToolAction.ADD) :
				sendAddPhraseRequest();
				break;
			case(ToolAction.EDIT) :
				close();
				break;
			case(ToolAction.REMOVE) :
				close();
				break;
			default :
				close();
				break;
		}
	}

	private function sendAddPhraseRequest():void {
		var suite:PhraseSuite = new PhraseSuite();
		suite.phrase = createPhrase();
		suite.themes = getSelectedThemes();
		sendRequest(PhraseMsg.ADD_PHRASE, new RequestMessage(addPhraseCompleteHandler, addPhraseErrorHandler, suite));
	}

	private function createPhrase():Phrase {
		var phrase:Phrase = new Phrase();
		phrase.origin = view.originArea.text;
		phrase.translation = view.translationArea.text;
		return phrase;
	}

	private function getSelectedThemes():Array {
		var res:Array = [];
		for each(var item:ThemeRendererData in view.themes) {
			if (item.selected) res.push(item.theme);
		}
		return res;
	}

	private function addPhraseCompleteHandler(suite:PhraseSuite):void {
		close();
	}

	private function addPhraseErrorHandler(msg:String):void {
		view.notifyInvalidData(msg);
	}

	override protected function onRemove():void {
		removeAllHandlers();
		view.cancelBtn.removeEventListener(MouseEvent.CLICK, cancelHandler);
		view.applyBtn.removeEventListener(MouseEvent.CLICK, applyHandler);
		selectedPhrase = Phrase.NULL;
		selectedToolAction = "";
	}

}
}