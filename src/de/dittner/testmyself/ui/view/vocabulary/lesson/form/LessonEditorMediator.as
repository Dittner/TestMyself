package de.dittner.testmyself.ui.view.vocabulary.lesson.form {
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.ui.view.vocabulary.note.form.NoteEditorMediator;

public class LessonEditorMediator extends NoteEditorMediator {

	override protected function activate():void {
		super.activate();
		autoFormat = false;
	}

	override protected function createNote():Note {
		var note:Note = new Note();
		note.title = view.titleArea.text;
		note.description = view.descriptionArea.text;
		note.audioComment = view.audioRecorder.comment;
		return note;
	}

	override protected function validateNote(note:Note):String {
		if (!note) return "Die Notiz fehlt!";
		if (!note.title || !note.description) return "Die Form is nicht ergänzt: Deutschtext und Übersetzung darf man nicht verpassen!";

		return validateDuplicateNote(note);
	}

	override protected function validateDuplicateNote(note:Note):String {
		if (!note) return "Die Notiz fehlt!";

		if (selectedNote) {
			if (note.title != selectedNote.title)
				if (note.title && noteHash.has(note)) return "Die Datenbank hat schon die gleiche Notiz!";
		}
		return "";
	}

}
}