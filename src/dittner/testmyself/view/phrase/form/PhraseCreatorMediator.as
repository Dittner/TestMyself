package dittner.testmyself.view.phrase.form {
import dittner.testmyself.command.operation.result.CommandException;
import dittner.testmyself.command.operation.result.CommandResult;
import dittner.testmyself.message.PhraseMsg;
import dittner.testmyself.view.common.mediator.RequestMessage;
import dittner.testmyself.view.common.toobar.ToolAction;
import dittner.testmyself.view.common.toobar.ToolActionName;

import flash.events.MouseEvent;

public class PhraseCreatorMediator extends PhraseFormMediator {

	override protected function toolActionSelectedHandler(toolAction:String):void {
		if (!isActive && toolAction == ToolAction.ADD) {
			isActive = true;
			form.add();
			form.title = ToolActionName.getNameById(ToolAction.ADD);
			openForm();
			loadThemes();
		}
	}

	override protected function applyHandler(event:MouseEvent):void {
		sendAddPhraseRequest();
	}

	private function sendAddPhraseRequest():void {
		var suite:Object = {};
		suite.phrase = createPhrase();
		suite.themes = getSelectedThemes();
		sendRequest(PhraseMsg.ADD_PHRASE, new RequestMessage(addPhraseCompleteHandler, addPhraseErrorHandler, suite));
	}

	private function addPhraseCompleteHandler(res:CommandResult):void {
		closeForm();
	}

	private function addPhraseErrorHandler(exc:CommandException):void {
		form.notifyInvalidData(exc.details);
	}

}
}