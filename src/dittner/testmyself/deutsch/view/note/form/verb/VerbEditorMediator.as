package dittner.testmyself.deutsch.view.note.form.verb {
import dittner.testmyself.core.model.note.Note;
import dittner.testmyself.deutsch.model.domain.verb.IVerb;
import dittner.testmyself.deutsch.model.domain.verb.Verb;
import dittner.testmyself.deutsch.view.note.form.*;

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
		if (!verb) return "Отсутствует глагол";
		if (!verb.title) return "Форма не заполнена: инфинитив не должен быть пустым";
		if (!verb.present || !verb.past || !verb.perfect) return "Форма не заполнена: поля präsens, präteritum, perfect не должны быть пустыми";

		if (selectedNote is IVerb) {
			var origin:IVerb = selectedNote as IVerb;
			if (origin.title != verb.title || origin.present != verb.present || origin.past != verb.past || origin.perfect != verb.perfect)
				if (noteHash.has(verb)) return "Глагол с такими данными уже существует в словаре";
		}
		return "";
	}

}
}