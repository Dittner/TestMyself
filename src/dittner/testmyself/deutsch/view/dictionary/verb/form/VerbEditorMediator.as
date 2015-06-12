package dittner.testmyself.deutsch.view.dictionary.verb.form {
import dittner.testmyself.core.model.note.Note;
import dittner.testmyself.deutsch.model.domain.verb.IVerb;
import dittner.testmyself.deutsch.model.domain.verb.Verb;
import dittner.testmyself.deutsch.view.dictionary.note.form.NoteEditorMediator;

public class VerbEditorMediator extends NoteEditorMediator {

	override protected function createNote():Note {
		var verb:Verb = new Verb();
		verb.title = view.verbInputsForm.infinitiveInput.text;
		verb.description = view.verbInputsForm.translateInput.text;
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