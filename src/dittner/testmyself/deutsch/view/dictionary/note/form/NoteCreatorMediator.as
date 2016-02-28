package dittner.testmyself.deutsch.view.dictionary.note.form {
import dittner.async.IAsyncOperation;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.core.model.note.NoteSuite;
import dittner.testmyself.deutsch.view.common.toobar.ToolAction;
import dittner.testmyself.deutsch.view.common.toobar.ToolActionName;

import flash.events.MouseEvent;

public class NoteCreatorMediator extends NoteFormMediator {

	override protected function toolActionSelectedHandler(toolAction:String):void {
		super.toolActionSelectedHandler(toolAction);
		if (!isActive && toolAction == ToolAction.ADD) {
			isActive = true;
			view.add();
			view.title = ToolActionName.getNameById(ToolAction.ADD);
			openForm();
			loadThemes();
		}
	}

	override protected function applyHandler(event:MouseEvent):void {
		var errMsg:String;
		var suite:NoteSuite = new NoteSuite();

		suite.note = createNote();
		errMsg = validateNote(suite.note);
		if (errMsg) {
			view.notifyInvalidData(errMsg);
			return;
		}

		suite.themes = createThemes();
		errMsg = validateThemes(suite.themes);
		if (errMsg) {
			view.notifyInvalidData(errMsg);
			return;
		}

		suite.examples = createExamples();
		errMsg = validateExamples(suite.examples);
		if (errMsg) {
			view.notifyInvalidData(errMsg);
			return;
		}
		send(suite);
	}

	override protected function send(suite:NoteSuite):void {
		sendRequest(NoteMsg.ADD_NOTE, new RequestMessage(addNoteCompleteHandler, suite));
	}

	protected function addNoteCompleteHandler(op:IAsyncOperation):void {
		if (op.isSuccess) closeForm();
		else view.notifyInvalidData(op.error.details);
	}

}
}