package dittner.testmyself.deutsch.view.dictionary.verb.form {
import dittner.testmyself.core.model.note.Note;
import dittner.testmyself.deutsch.model.domain.verb.IVerb;
import dittner.testmyself.deutsch.model.domain.verb.Verb;
import dittner.testmyself.deutsch.view.dictionary.note.form.NoteCreatorMediator;

public class VerbCreatorMediator extends NoteCreatorMediator {

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

	override protected function validateNote(note:Note, onlyDuplicateChecking:Boolean = false):String {
		var verb:IVerb = note as IVerb;
		if (!verb) return "Отсутствует глагол";

		if (!onlyDuplicateChecking) {
			if (!verb.title) return "Форма не заполнена: инфинитив не должен быть пустым";
			if (!verb.present || !verb.past || !verb.perfect) return "Форма не заполнена: поля präsens, präteritum, perfect не должны быть пустыми";
		}

		if (noteHash.has(verb)) return "Глагол с такими данными уже существует в словаре";
		return "";
	}

}
}