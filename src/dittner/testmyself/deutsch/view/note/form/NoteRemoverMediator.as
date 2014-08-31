package dittner.testmyself.deutsch.view.note.form {
import dittner.satelliteFlight.command.CommandException;
import dittner.satelliteFlight.command.CommandResult;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.deutsch.view.common.toobar.ToolAction;
import dittner.testmyself.deutsch.view.common.toobar.ToolActionName;

import flash.events.MouseEvent;

public class NoteRemoverMediator extends NoteFormMediator {

	override protected function toolActionSelectedHandler(toolAction:String):void {
		if (!isActive && toolAction == ToolAction.REMOVE && selectedNote) {
			isActive = true;
			view.remove(selectedNote.title);
			view.title = ToolActionName.getNameById(ToolAction.REMOVE);
			openForm();
		}
	}

	override protected function applyHandler(event:MouseEvent):void {
		sendRemoveUnitRequest();
	}

	private function sendRemoveUnitRequest():void {
		sendRequest(NoteMsg.REMOVE_NOTE, new RequestMessage(removeUnitCompleteHandler, removeUnitErrorHandler, selectedNote));
	}

	private function removeUnitCompleteHandler(res:CommandResult):void {
		closeForm();
	}

	private function removeUnitErrorHandler(exc:CommandException):void {
		view.notifyInvalidData(exc.details);
	}

}
}