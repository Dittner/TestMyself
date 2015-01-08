package dittner.testmyself.deutsch.view.dictionary.phrase.form {
import dittner.testmyself.core.model.note.Note;
import dittner.testmyself.deutsch.view.dictionary.note.form.NoteEditorMediator;

public class PhraseEditorMediator extends NoteEditorMediator {

	override protected function createNote():Note {
		var note:Note = new Note();
		note.title = view.titleArea.text;
		note.description = view.descriptionArea.text;
		note.audioComment = view.audioRecorder.comment;
		return note;
	}

	override protected function validateNote(note:Note, onlyDuplicateChecking:Boolean = false):String {
		if (!note) return "Отсутствует фраза";
		if (!onlyDuplicateChecking && (!note.title || !note.description)) return "Форма не заполнена: исходный текст и перевод не должны быть пустыми";

		if (selectedNote) {
			if (note.title != selectedNote.title)
				if (note.title && noteHash.has(note)) return "Фраза с таким исходным текстом уже существует в словаре";
		}
		return "";
	}

}
}