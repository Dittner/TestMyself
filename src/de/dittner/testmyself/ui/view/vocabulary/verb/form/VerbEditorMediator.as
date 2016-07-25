package de.dittner.testmyself.ui.view.vocabulary.verb.form {
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.note.verb.DeVerb;
import de.dittner.testmyself.ui.view.vocabulary.note.form.NoteEditorMediator;

public class VerbEditorMediator extends NoteEditorMediator {

	override protected function createNote():Note {
		var verb:DeVerb = new DeVerb();
		verb.title = view.verbInputsForm.infinitiveInput.text;
		verb.description = correctDescriptionText(view.descriptionArea.text);
		verb.audioComment = view.audioRecorder.comment;
		verb.present = view.verbInputsForm.presentInput.text;
		verb.past = view.verbInputsForm.pastInput.text;
		verb.perfect = view.verbInputsForm.perfectInput.text;
		return verb;
	}

	override protected function validateNote(note:Note):String {
		var verb:IVerb = note as IVerb;
		if (!verb) return "Die Notiz fehlt!";

		if (!verb.title) return "Die Form is nicht ergänzt: Infinitiv darf man nicht verpassen!";
		if (!verb.present || !verb.past || !verb.perfect) return "Die Form is nicht ergänzt: Präsens, Präteritum und Partizip II darf man nicht verpassen!";

		return validateDuplicateNote(note);
	}

	override protected function validateDuplicateNote(note:Note):String {
		var verb:IVerb = note as IVerb;
		if (!verb) return "Die Notiz fehlt!";

		if (selectedNote is IVerb) {
			var origin:IVerb = selectedNote as IVerb;
			if (origin.title != verb.title)
				if (noteHash.has(verb)) return "Die Datenbank hat schon die gleiche Notiz!";
		}
		return "";
	}

}
}