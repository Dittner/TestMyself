package de.dittner.testmyself.ui.view.test.form {
import de.dittner.testmyself.backend.message.NoteMsg;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.note.NoteSuite;
import de.dittner.testmyself.ui.view.vocabulary.note.form.NoteEditorMediator;

import flash.events.MouseEvent;

public class ExampleEditorMediator extends NoteEditorMediator {

	override protected function createNote():Note {
		var note:Note = new Note();
		note.title = view.titleArea.text;
		note.description = view.descriptionArea.text;
		note.audioComment = view.audioRecorder.comment;
		return note;
	}

	override protected function loadExamples():void {}

	override protected function applyHandler(event:MouseEvent):void {
		var errMsg:String;
		var suite:NoteSuite = new NoteSuite();

		suite.note = createNote();
		suite.origin = selectedNote;
		suite.note.id = selectedNote.id;
		errMsg = validateExample(suite.note);
		if (errMsg) {
			view.notifyInvalidData(errMsg);
			return;
		}
		send(suite);
	}

	override protected function send(suite:NoteSuite):void {
		sendRequest(NoteMsg.UPDATE_EXAMPLE, new RequestMessage(updateNoteCompleteHandler, suite));
	}

	override protected function validateNote(note:Note):String {
		if (!note) return "Die Notiz fehlt!";
		if (!note.title || !note.description) return "Die Form is nicht ergänzt: Deutschtext und Übersetzung darf man nicht verpassen!";
		return "";
	}

}
}