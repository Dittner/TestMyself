package dittner.testmyself.view.phrase {
import dittner.testmyself.command.operation.result.CommandResult;
import dittner.testmyself.message.PhraseMsg;
import dittner.testmyself.message.ScreenMsg;
import dittner.testmyself.utils.pendingInvoke.doLaterInFrames;
import dittner.testmyself.view.common.mediator.RequestMediator;
import dittner.testmyself.view.common.mediator.RequestMessage;
import dittner.testmyself.view.phrase.filter.PhraseFilterMediator;
import dittner.testmyself.view.phrase.form.PhraseCreatorMediator;
import dittner.testmyself.view.phrase.form.PhraseEditorMediator;
import dittner.testmyself.view.phrase.form.PhraseRemoverMediator;
import dittner.testmyself.view.phrase.list.PhraseListMediator;
import dittner.testmyself.view.phrase.pagination.PhrasePaginationMediator;
import dittner.testmyself.view.phrase.toolbar.PhraseToolbarMediator;

public class PhraseScreenMediator extends RequestMediator {

	[Inject]
	public var view:PhraseScreen;

	override protected function onRegister():void {
		sendMessage(ScreenMsg.LOCK_UI);
		doLaterInFrames(preActivation, 5);
	}

	private function preActivation():void {
		sendRequest(PhraseMsg.GET_PAGE_INFO, new RequestMessage(onPageInfoLoaded));
	}

	private function onPageInfoLoaded(res:CommandResult):void {
		activateScreen()
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
		mediatorMap.mediateWith(view.paginationBar, PhrasePaginationMediator);
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
		mediatorMap.unmediate(view.paginationBar, PhrasePaginationMediator);
	}

	private function showEditor(params:* = null):void {
		view.showEditor();
	}
	private function hideEditor(params:* = null):void {
		view.hideEditor();
	}

}
}