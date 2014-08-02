package dittner.testmyself.view.phrase {
import dittner.testmyself.message.PhraseMsg;
import dittner.testmyself.message.ScreenMsg;
import dittner.testmyself.service.helpers.toolFactory.Tool;
import dittner.testmyself.service.helpers.toolFactory.ToolId;
import dittner.testmyself.utils.pendingInvoke.doLaterInFrames;

import mvcexpress.mvc.Mediator;

public class PhraseMediator extends Mediator {

	[Inject]
	public var view:PhraseScreen;

	override protected function onRegister():void {
		sendMessage(ScreenMsg.LOCK_UI);
		doLaterInFrames(activateScreen, 20);
	}

	private function activateScreen():void {
		view.activate();
		addHandler(PhraseMsg.TOOL_SELECTED_NOTIFICATION, toolSelectedHandler);
		mediatorMap.mediateWith(view.toolbar, PhraseToolbarMediator);
		mediatorMap.mediateWith(view.editor, PhraseEditorMediator);
		sendMessage(ScreenMsg.UNLOCK_UI);
	}

	override protected function onRemove():void {
		removeAllHandlers();
		mediatorMap.unmediate(view.toolbar, PhraseToolbarMediator);
		mediatorMap.unmediate(view.editor, PhraseEditorMediator);
		sendMessage(PhraseMsg.CLEAR_MODEL);
	}

	private function toolSelectedHandler(tool:Tool):void {
		if (tool.id == ToolId.ADD || tool.id == ToolId.EDIT || tool.id == ToolId.REMOVE) view.showEditor();
		else view.hideEditor();
	}
}
}