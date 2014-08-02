package dittner.testmyself.view.phrase {
import dittner.testmyself.message.PhraseMsg;
import dittner.testmyself.model.vo.ThemeVo;
import dittner.testmyself.service.helpers.toolFactory.ToolId;
import dittner.testmyself.service.helpers.toolFactory.Tool;
import dittner.testmyself.view.common.mediator.RequestOperationMessage;
import dittner.testmyself.view.common.mediator.SmartMediator;
import dittner.testmyself.view.phrase.components.ThemeRendererData;

import flash.events.MouseEvent;

import mx.collections.ArrayCollection;

public class PhraseEditorMediator extends SmartMediator {

	[Inject]
	public var view:PhraseEditor;

	override protected function onRegister():void {
		view.cancelBtn.addEventListener(MouseEvent.CLICK, cancelHandler);
		addHandler(PhraseMsg.TOOL_SELECTED_NOTIFICATION, toolSelectedHandler);
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

	private function toolSelectedHandler(tool:Tool):void {
		switch (tool.id) {
			case(ToolId.ADD) :
				view.add();
				break;
			case(ToolId.EDIT) :
				view.edit(null);
				break;
			case(ToolId.REMOVE) :
				view.remove(null);
				break;
			default :
				view.close();
		}
		view.title = tool.description;
	}

	override protected function onRemove():void {
		removeAllHandlers();
		view.cancelBtn.removeEventListener(MouseEvent.CLICK, cancelHandler);
	}

	private function cancelHandler(event:MouseEvent):void {
		view.close();
		sendMessage(PhraseMsg.SELECT_TOOL, Tool.NULL);
	}
}
}