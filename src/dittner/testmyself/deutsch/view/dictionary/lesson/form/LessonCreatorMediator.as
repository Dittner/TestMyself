package dittner.testmyself.deutsch.view.dictionary.lesson.form {
import de.dittner.async.IAsyncOperation;

import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.core.model.note.Note;
import dittner.testmyself.core.model.note.NoteFilter;
import dittner.testmyself.deutsch.view.dictionary.note.form.NoteCreatorMediator;

public class LessonCreatorMediator extends NoteCreatorMediator {

	override protected function activate():void {
		super.activate();
		autoFormat = false;
		sendRequest(NoteMsg.GET_FILTER, new RequestMessage(filterLoaded));
	}

	private var selectedFilter:NoteFilter;
	private function filterLoaded(op:IAsyncOperation):void {
		selectedFilter = op.result as NoteFilter;
	}

	override protected function createThemes():Array {
		if (selectedFilter) return selectedFilter.selectedThemes;
		else throw new Error("Expected selected filter to create task for Lesson!");
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
		if (note.title && noteHash.has(note)) return "Die Datenbank hat schon die gleiche Notiz!";
		return "";
	}
}
}