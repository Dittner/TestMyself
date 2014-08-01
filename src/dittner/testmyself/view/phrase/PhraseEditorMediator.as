package dittner.testmyself.view.phrase {
import dittner.testmyself.message.PhraseMsg;
import dittner.testmyself.service.helpers.toolFactory.ToolInfo;

import mvcexpress.mvc.Mediator;

import mx.collections.ArrayCollection;

public class PhraseEditorMediator extends Mediator {

	[Inject]
	public var view:PhraseEditor;

	override protected function onRegister():void {
		addHandler(PhraseMsg.ON_THEMES, onThemesLoaded);
		addHandler(PhraseMsg.TOOL_SELECTED_NOTIFICATION, toolSelectedHandler);

		sendMessage(PhraseMsg.GET_THEMES);
	}

	private function onThemesLoaded(themes:Array):void {
		view.themes = new ArrayCollection(themes);
	}

	private function toolSelectedHandler(tool:ToolInfo):void {
		view.toolInfo = tool;
	}

	override protected function onRemove():void {

	}
}
}