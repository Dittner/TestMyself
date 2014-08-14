package dittner.testmyself.view.phrase {
import dittner.testmyself.message.PhraseMsg;
import dittner.testmyself.message.ScreenMsg;
import dittner.testmyself.utils.pendingInvoke.doLaterInFrames;
import dittner.testmyself.view.phrase.filter.PhraseFilterMediator;
import dittner.testmyself.view.phrase.form.PhraseCreatorMediator;
import dittner.testmyself.view.phrase.form.PhraseEditorMediator;
import dittner.testmyself.view.phrase.form.PhraseRemoverMediator;
import dittner.testmyself.view.phrase.list.PhraseListMediator;
import dittner.testmyself.view.phrase.toolbar.PhraseToolbarMediator;

import mvcexpress.mvc.Mediator;

public class PhraseScreenMediator extends Mediator {

	[Inject]
	public var view:PhraseScreen;

	override protected function onRegister():void {
		sendMessage(ScreenMsg.LOCK_UI);
		doLaterInFrames(activateScreen, 10);
	}

	private function activateScreen():void {
		view.activate();
		addHandler(PhraseMsg.FORM_ACTIVATED_NOTIFICATION, showEditor);
		addHandler(PhraseMsg.FORM_DEACTIVATED_NOTIFICATION, hideEditor);
		mediatorMap.mediateWith(view.toolbar, PhraseToolbarMediator);
		mediatorMap.mediateWith(view.form, PhraseCreatorMediator);
		mediatorMap.mediateWith(view.form, PhraseEditorMediator);
		mediatorMap.mediateWith(view.form, PhraseRemoverMediator);
		mediatorMap.mediateWith(view.list, PhraseListMediator);
		mediatorMap.mediateWith(view.filter, PhraseFilterMediator);
		sendMessage(ScreenMsg.UNLOCK_UI);
	}

	override protected function onRemove():void {
		removeAllHandlers();
		mediatorMap.unmediate(view.toolbar, PhraseToolbarMediator);
		mediatorMap.unmediate(view.form, PhraseCreatorMediator);
		mediatorMap.unmediate(view.form, PhraseEditorMediator);
		mediatorMap.unmediate(view.form, PhraseRemoverMediator);
		mediatorMap.unmediate(view.list, PhraseListMediator);
		mediatorMap.unmediate(view.filter, PhraseFilterMediator);
	}

	private function showEditor(params:* = null):void {
		view.showEditor();
	}
	private function hideEditor(params:* = null):void {
		view.hideEditor();
	}

}
}