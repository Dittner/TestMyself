package dittner.testmyself.view.phrase {
import dittner.testmyself.message.PhraseMsg;
import dittner.testmyself.service.helpers.toolFactory.ToolInfo;

import mvcexpress.mvc.Mediator;

public class PhraseEditorMediator extends Mediator {

	[Inject]
	public var view:PhraseEditor;

	override protected function onRegister():void {
		addHandler(PhraseMsg.TOOL_SELECTED_NOTIFICATION, toolSelectedHandler);
	}

	private function toolSelectedHandler(tool:ToolInfo):void {
		view.selectedTool = tool;
	}

	override protected function onRemove():void {

	}
}
}