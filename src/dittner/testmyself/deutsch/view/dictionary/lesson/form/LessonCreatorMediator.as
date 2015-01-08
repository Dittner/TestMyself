package dittner.testmyself.deutsch.view.dictionary.lesson.form {
import dittner.satelliteFlight.command.CommandResult;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.core.model.note.Note;
import dittner.testmyself.core.model.note.NoteFilter;
import dittner.testmyself.deutsch.view.dictionary.note.form.NoteCreatorMediator;

public class LessonCreatorMediator extends NoteCreatorMediator {

	override protected function activate():void {
		super.activate();
		sendRequest(NoteMsg.GET_FILTER, new RequestMessage(filterLoaded));
	}

	private var selectedFilter:NoteFilter;
	private function filterLoaded(res:CommandResult):void {
		selectedFilter = res.data as NoteFilter;
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

	override protected function validateNote(note:Note, onlyDuplicateChecking:Boolean = false):String {
		if (!note) return "Отсутствует задача";
		if (!onlyDuplicateChecking && (!note.title || !note.description)) return "Форма не заполнена: исходный текст и перевод не должны быть пустыми";
		if (note.title && noteHash.has(note)) return "Запись с таким исходным текстом уже существует в словаре";
		return "";
	}

}
}