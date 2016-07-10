package de.dittner.testmyself.ui.view.test.form {
import de.dittner.satelliteFlight.message.RequestMessage;
import de.dittner.testmyself.backend.message.NoteMsg;
import de.dittner.testmyself.model.domain.note.NoteSuite;
import de.dittner.testmyself.ui.view.dictionary.note.form.*;

public class ExampleRemoverMediator extends NoteRemoverMediator {

	override protected function sendRemoveUnitRequest():void {
		var suite:NoteSuite = new NoteSuite();
		suite.note = selectedNote;
		sendRequest(NoteMsg.REMOVE_EXAMPLE, new RequestMessage(removeUnitCompleteHandler, suite));
	}

}
}