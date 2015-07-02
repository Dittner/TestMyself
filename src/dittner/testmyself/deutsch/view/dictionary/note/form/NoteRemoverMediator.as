package dittner.testmyself.deutsch.view.dictionary.note.form {
import dittner.satelliteFlight.command.CommandException;
import dittner.satelliteFlight.command.CommandResult;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.core.model.note.NoteSuite;
import dittner.testmyself.deutsch.view.common.toobar.ToolAction;
import dittner.testmyself.deutsch.view.common.toobar.ToolActionName;

import flash.events.MouseEvent;

public class NoteRemoverMediator extends NoteFormMediator {

	override protected function toolActionSelectedHandler(toolAction:String):void {
		super.toolActionSelectedHandler(toolAction);
		if (!isActive && toolAction == ToolAction.REMOVE && selectedNote) {
			isActive = true;
			view.remove(selectedNote);
			view.title = ToolActionName.getNameById(ToolAction.REMOVE);
			openForm();
		}
	}

	override protected function applyHandler(event:MouseEvent):void {
		sendRemoveUnitRequest();
	}

	protected function sendRemoveUnitRequest():void {
		var suite:NoteSuite = new NoteSuite();
		suite.note = selectedNote;
		sendRequest(NoteMsg.REMOVE_NOTE, new RequestMessage(removeUnitCompleteHandler, removeUnitErrorHandler, suite));
	}

	protected function removeUnitCompleteHandler(res:CommandResult):void {
		closeForm();
	}

	protected function removeUnitErrorHandler(exc:CommandException):void {
		view.notifyInvalidData(exc.details);
	}

}
}