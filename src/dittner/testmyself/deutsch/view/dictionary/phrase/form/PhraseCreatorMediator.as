package dittner.testmyself.deutsch.view.dictionary.phrase.form {
import dittner.testmyself.core.model.note.Note;
import dittner.testmyself.deutsch.view.dictionary.note.form.NoteCreatorMediator;

public class PhraseCreatorMediator extends NoteCreatorMediator {

	override protected function createNote():Note {
		var note:Note = new Note();
		note.title = view.titleArea.text;
		note.description = view.descriptionArea.text;
		note.audioComment = view.audioRecorder.comment;
		return note;
	}

	override protected function validateNote(note:Note):String {
		if (!note) return "Отсутствует фраза";
		if (!note.title || !note.description) return "Форма не заполнена: исходный текст и перевод не должны быть пустыми";
		return validateDuplicateNote(note);
	}

	override protected function validateDuplicateNote(note:Note):String {
		if (!note) return "Отсутствует фраза";
		if (note.title && noteHash.has(note)) return "Фраза с таким исходным текстом уже существует в словаре";
		return "";
	}

}
}