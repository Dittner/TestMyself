package dittner.testmyself.view.phrase.editor {
import dittner.testmyself.message.PhraseMsg;
import dittner.testmyself.model.phrase.PhraseVo;
import dittner.testmyself.model.common.LanguageUnitVo;
import dittner.testmyself.model.theme.ThemeVo;
import dittner.testmyself.view.common.mediator.RequestOperationMessage;
import dittner.testmyself.view.common.mediator.SmartMediator;
import dittner.testmyself.view.common.toobar.ToolAction;
import dittner.testmyself.view.common.toobar.ToolActionName;
import dittner.testmyself.view.phrase.common.ThemeRendererData;

import flash.events.MouseEvent;

import mx.collections.ArrayCollection;

public class PhraseEditorMediator extends SmartMediator {

	[Inject]
	public var view:PhraseEditor;

	private var selectedPhrase:LanguageUnitVo = PhraseVo.NULL;

	override protected function onRegister():void {
		view.cancelBtn.addEventListener(MouseEvent.CLICK, cancelHandler);
		addHandler(PhraseMsg.TOOL_ACTION_SELECTED_NOTIFICATION, toolActionSelectedHandler);
		addHandler(PhraseMsg.PHRASE_SELECTED_NOTIFICATION, phraseSelectedHandler);
		requestData(PhraseMsg.GET_THEMES, new RequestOperationMessage(onThemesLoaded));
	}

	private function onThemesLoaded(themes:Array):void {
		var themeItems:Array = wrapThemes(themes);
		view.themes = new ArrayCollection(themeItems);
	}

	private function wrapThemes(themes:Array):Array {
		var items:Array = [];
		var item:ThemeRendererData;
		for each(var vo:ThemeVo in themes) {
			item = new ThemeRendererData(vo);
			items.push(item);
		}
		return items;
	}

	private function toolActionSelectedHandler(toolAction:String):void {
		var activateEditor:Boolean = true;
		switch (toolAction) {
			case(ToolAction.ADD) :
				view.add();
				break;
			case(ToolAction.EDIT) :
				view.edit(selectedPhrase);
				break;
			case(ToolAction.REMOVE) :
				view.remove(selectedPhrase);
				break;
			default :
				activateEditor = false;
				view.close();
				break;
		}
		view.title = ToolActionName.getNameById(toolAction);
		sendMessage(activateEditor ? PhraseMsg.EDITOR_ACTIVATED_NOTIFICATION : PhraseMsg.EDITOR_DEACTIVATED_NOTIFICATION);
	}

	private function phraseSelectedHandler(vo:LanguageUnitVo):void {
		selectedPhrase = vo;
		if (view.isOpen()) throw new Error("Should not select new phrase when the old one is editing!")
	}

	private function cancelHandler(event:MouseEvent):void {
		view.close();
		sendMessage(PhraseMsg.EDITOR_DEACTIVATED_NOTIFICATION);
	}

	override protected function onRemove():void {
		removeAllHandlers();
		view.cancelBtn.removeEventListener(MouseEvent.CLICK, cancelHandler);
		selectedPhrase = PhraseVo.NULL;
	}

}
}