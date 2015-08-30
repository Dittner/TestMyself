package dittner.testmyself.deutsch.view.test.form {
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.core.model.note.NoteSuite;
import dittner.testmyself.deutsch.view.dictionary.note.form.*;

public class ExampleRemoverMediator extends NoteRemoverMediator {

	override protected function sendRemoveUnitRequest():void {
		var suite:NoteSuite = new NoteSuite();
		suite.note = selectedNote;
		sendRequest(NoteMsg.REMOVE_EXAMPLE, new RequestMessage(removeUnitCompleteHandler, suite));
	}

}
}