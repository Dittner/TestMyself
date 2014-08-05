package dittner.testmyself.view.phrase {
import dittner.testmyself.message.PhraseMsg;
import dittner.testmyself.message.ScreenMsg;
import dittner.testmyself.utils.pendingInvoke.doLaterInFrames;
import dittner.testmyself.view.phrase.editor.PhraseEditorMediator;
import dittner.testmyself.view.phrase.list.PhraseListMediator;
import dittner.testmyself.view.phrase.toolbar.PhraseToolbarMediator;

import mvcexpress.mvc.Mediator;

public class PhraseScreenMediator extends Mediator {

	[Inject]
	public var view:PhraseScreen;

	override protected function onRegister():void {
		sendMessage(ScreenMsg.LOCK_UI);
		doLaterInFrames(activateScreen, 20);
	}

	private function activateScreen():void {
		view.activate();
		addHandler(PhraseMsg.EDITOR_ACTIVATED_NOTIFICATION, showEditor);
		addHandler(PhraseMsg.EDITOR_DEACTIVATED_NOTIFICATION, hideEditor);
		mediatorMap.mediateWith(view.toolbar, PhraseToolbarMediator);
		mediatorMap.mediateWith(view.editor, PhraseEditorMediator);
		mediatorMap.mediateWith(view.list, PhraseListMediator);
		sendMessage(ScreenMsg.UNLOCK_UI);
	}

	override protected function onRemove():void {
		removeAllHandlers();
		mediatorMap.unmediate(view.toolbar, PhraseToolbarMediator);
		mediatorMap.unmediate(view.editor, PhraseEditorMediator);
		mediatorMap.unmediate(view.list, PhraseListMediator);
		sendMessage(PhraseMsg.CLEAR_MODEL);
	}

	private function showEditor(params:* = null):void {
		view.showEditor();
	}
	private function hideEditor(params:* = null):void {
		view.hideEditor();
	}

}
}