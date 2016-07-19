package de.dittner.testmyself.ui.view.dictionary.note.form {
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.message.NoteMsg;
import de.dittner.testmyself.model.domain.note.NoteSuite;
import de.dittner.testmyself.ui.common.toobar.ToolAction;
import de.dittner.testmyself.ui.common.toobar.ToolActionName;

import flash.events.MouseEvent;

public class NoteCreatorMediator extends NoteFormMediator {

	override protected function toolActionSelectedHandler(toolAction:String):void {
		super.toolActionSelectedHandler(toolAction);
		if (!isActive && toolAction == ToolAction.ADD) {
			isActive = true;
			view.add();
			view.title = ToolActionName.getNameByID(ToolAction.ADD);
			openForm();
			loadThemes();
		}
	}

	override protected function applyHandler(event:MouseEvent):void {
		if (autoFormat) formatFields();
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