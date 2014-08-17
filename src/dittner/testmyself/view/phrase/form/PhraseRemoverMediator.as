package dittner.testmyself.view.phrase.form {
import dittner.testmyself.command.operation.result.CommandException;
import dittner.testmyself.command.operation.result.CommandResult;
import dittner.testmyself.message.PhraseMsg;
import dittner.testmyself.model.phrase.Phrase;
import dittner.testmyself.view.common.mediator.RequestMessage;
import dittner.testmyself.view.common.toobar.ToolAction;
import dittner.testmyself.view.common.toobar.ToolActionName;

import flash.events.MouseEvent;

public class PhraseRemoverMediator extends PhraseFormMediator {

	override protected function toolActionSelectedHandler(toolAction:String):void {
		if (!isActive && toolAction == ToolAction.REMOVE && selectedPhrase != Phrase.NULL) {
			isActive = true;
			form.remove(selectedPhrase.origin);
			form.title = ToolActionName.getNameById(ToolAction.REMOVE);
			openForm();
		}
	}

	override protected function applyHandler(event:MouseEvent):void {
		sendRemovePhraseRequest();
	}

	private function sendRemovePhraseRequest():void {
		sendRequest(PhraseMsg.REMOVE_PHRASE, new RequestMessage(removePhraseCompleteHandler, removePhraseErrorHandler, selectedPhrase));
	}

	private function removePhraseCompleteHandler(res:CommandResult):void {
		closeForm();
	}

	private function removePhraseErrorHandler(exc:CommandException):void {
		form.notifyInvalidData(exc.details);
	}

}
}