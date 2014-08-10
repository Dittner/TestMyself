package dittner.testmyself.view.phrase.form {
import dittner.testmyself.command.operation.result.CommandException;
import dittner.testmyself.command.operation.result.CommandResult;
import dittner.testmyself.message.PhraseMsg;
import dittner.testmyself.model.phrase.IPhrase;
import dittner.testmyself.model.phrase.Phrase;
import dittner.testmyself.view.common.mediator.RequestMediator;
import dittner.testmyself.view.common.mediator.RequestMessage;
import dittner.testmyself.view.common.toobar.ToolAction;
import dittner.testmyself.view.common.toobar.ToolActionName;

import flash.events.MouseEvent;

public class PhraseRemoverMediator extends RequestMediator {

	[Inject]
	public var view:PhraseForm;

	private var selectedPhrase:IPhrase = Phrase.NULL;
	private var isRemoving:Boolean = false;

	override protected function onRegister():void {
		addHandler(PhraseMsg.TOOL_ACTION_SELECTED_NOTIFICATION, toolActionSelectedHandler);
		addHandler(PhraseMsg.PHRASE_SELECTED_NOTIFICATION, phraseSelectedHandler);
	}

	private function toolActionSelectedHandler(toolAction:String):void {
		if (!isRemoving && toolAction == ToolAction.REMOVE && selectedPhrase != Phrase.NULL) {
			openForm();
		}
	}

	private function openForm():void {
		isRemoving = true;
		view.remove(selectedPhrase.origin, selectedPhrase.translation);
		view.title = ToolActionName.getNameById(ToolAction.REMOVE);
		sendMessage(PhraseMsg.FORM_ACTIVATED_NOTIFICATION);
		view.cancelBtn.addEventListener(MouseEvent.CLICK, cancelHandler);
		view.applyBtn.addEventListener(MouseEvent.CLICK, applyHandler);
	}

	private function cancelHandler(event:MouseEvent):void {
		closeForm();
	}

	private function closeForm():void {
		isRemoving = false;
		view.close();
		sendMessage(PhraseMsg.FORM_DEACTIVATED_NOTIFICATION);
		view.cancelBtn.removeEventListener(MouseEvent.CLICK, cancelHandler);
		view.applyBtn.removeEventListener(MouseEvent.CLICK, applyHandler);
	}

	private function phraseSelectedHandler(vo:Phrase):void {
		selectedPhrase = vo;
		if (isRemoving) throw new Error("Should not select new phrase when the old one is removing!")
	}

	private function applyHandler(event:MouseEvent):void {
		sendRemovePhraseRequest();
	}

	private function sendRemovePhraseRequest():void {
		sendRequest(PhraseMsg.REMOVE_PHRASE, new RequestMessage(removePhraseCompleteHandler, removePhraseErrorHandler, selectedPhrase));
	}

	private function removePhraseCompleteHandler(res:CommandResult):void {
		closeForm();
	}

	private function removePhraseErrorHandler(exc:CommandException):void {
		view.notifyInvalidData(exc.details);
	}

	override protected function onRemove():void {
		removeAllHandlers();
		if (isRemoving) {
			isRemoving = false;
			closeForm();
		}
	}

}
}