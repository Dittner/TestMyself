package de.dittner.testmyself.ui.view.vocabulary.note.form {
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.message.NoteMsg;
import de.dittner.testmyself.model.domain.note.NoteSuite;
import de.dittner.testmyself.ui.common.toobar.ToolAction;
import de.dittner.testmyself.ui.common.toobar.ToolActionName;

import flash.events.MouseEvent;

public class NoteRemoverMediator extends NoteFormMediator {

	override protected function toolActionSelectedHandler(toolAction:String):void {
		super.toolActionSelectedHandler(toolAction);
		if (!isActive && toolAction == ToolAction.REMOVE && selectedNote) {
			isActive = true;
			view.remove(selectedNote);
			view.title = ToolActionName.getNameByID(ToolAction.REMOVE);
			openForm();
		}
	}

	override protected function applyHandler(event:MouseEvent):void {
		sendRemoveUnitRequest();
	}

	protected function sendRemoveUnitRequest():void {
		var suite:NoteSuite = new NoteSuite();
		suite.note = selectedNote;
		sendRequest(NoteMsg.REMOVE_NOTE, new RequestMessage(removeUnitCompleteHandler, suite));
	}

	protected function removeUnitCompleteHandler(op:IAsyncOperation):void {
		if (op.isSuccess) closeForm();
		else view.notifyInvalidData(op.error.details);
	}

}
}