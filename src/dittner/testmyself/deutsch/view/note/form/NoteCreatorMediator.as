package dittner.testmyself.deutsch.view.note.form {
import dittner.satelliteFlight.command.CommandException;
import dittner.satelliteFlight.command.CommandResult;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.deutsch.view.common.toobar.ToolAction;
import dittner.testmyself.deutsch.view.common.toobar.ToolActionName;

import flash.events.MouseEvent;

public class NoteCreatorMediator extends NoteFormMediator {

	override protected function toolActionSelectedHandler(toolAction:String):void {
		if (!isActive && toolAction == ToolAction.ADD) {
			isActive = true;
			view.add();
			view.title = ToolActionName.getNameById(ToolAction.ADD);
			openForm();
			loadThemes();
		}
	}

	override protected function applyHandler(event:MouseEvent):void {
		sendAddNoteRequest();
	}

	private function sendAddNoteRequest():void {
		var suite:Object = {};
		suite.note = createNote();
		suite.themes = getSelectedThemes();
		sendRequest(NoteMsg.ADD_NOTE, new RequestMessage(addNoteCompleteHandler, addNoteErrorHandler, suite));
	}

	private function addNoteCompleteHandler(res:CommandResult):void {
		closeForm();
	}

	private function addNoteErrorHandler(exc:CommandException):void {
		view.notifyInvalidData(exc.details);
	}

}
}