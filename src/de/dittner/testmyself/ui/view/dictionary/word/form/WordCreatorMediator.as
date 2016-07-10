package de.dittner.testmyself.ui.view.dictionary.word.form {
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.word.Word;
import de.dittner.testmyself.ui.view.dictionary.note.form.NoteCreatorMediator;

public class WordCreatorMediator extends NoteCreatorMediator {

	override protected function createNote():Note {
		var word:Word = new Word();
		word.title = view.wordInput.text;
		word.description = view.descriptionArea.text;
		word.audioComment = view.audioRecorder.comment;
		word.article = view.articleBox.selectedItem;
		word.options = view.wordOptionsInput.text;
		return word;
	}

	override protected function validateNote(note:Note):String {
		if (!note) return "Die Notiz fehlt!";
		if (!note.title || !note.description) return "Die Form is nicht ergänzt: Deutschtext und Übersetzung darf man nicht verpassen!";
		return validateDuplicateNote(note);
	}

	override protected function validateDuplicateNote(note:Note):String {
		if (!note) return "Die Notiz fehlt!";
		if (note.title && noteHash.has(note)) return "Die Datenbank hat schon die gleiche Notiz!";
		return "";
	}

}
}