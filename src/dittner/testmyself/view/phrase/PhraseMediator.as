package dittner.testmyself.view.phrase {
import dittner.testmyself.message.PhraseMsg;

import mvcexpress.mvc.Mediator;

public class PhraseMediator extends Mediator {

	[Inject]
	public var view:PhraseScreen;

	override protected function onRegister():void {
		addHandler(PhraseMsg.TOOL_SELECTED_NOTIFICATION, toolSelectedHandler);
		mediatorMap.mediateWith(view.toolbar, PhraseToolbarMediator);
		mediatorMap.mediateWith(view.editor, PhraseEditorMediator);
	}

	override protected function onRemove():void {
		removeAllHandlers();
		mediatorMap.unmediate(view.toolbar, PhraseToolbarMediator);
		mediatorMap.unmediate(view.editor, PhraseEditorMediator);
		sendMessage(PhraseMsg.CLEAR_MODEL);
	}

	private function toolSelectedHandler(tool:*):void {
		if (tool) view.activateEditMode();
		else view.deactivateEditMode();
	}
}
}