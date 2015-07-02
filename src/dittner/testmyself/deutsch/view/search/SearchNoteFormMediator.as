package dittner.testmyself.deutsch.view.search {
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.core.message.SearchMsg;
import dittner.testmyself.deutsch.model.ModuleName;
import dittner.testmyself.deutsch.model.search.FoundNote;
import dittner.testmyself.deutsch.view.common.toobar.ToolAction;
import dittner.testmyself.deutsch.view.dictionary.lesson.form.LessonEditorMediator;
import dittner.testmyself.deutsch.view.dictionary.note.form.NoteEditorMediator;
import dittner.testmyself.deutsch.view.dictionary.note.form.NoteForm;
import dittner.testmyself.deutsch.view.dictionary.note.form.NoteRemoverMediator;
import dittner.testmyself.deutsch.view.dictionary.phrase.form.PhraseEditorMediator;
import dittner.testmyself.deutsch.view.dictionary.verb.form.VerbEditorMediator;
import dittner.testmyself.deutsch.view.dictionary.word.form.WordEditorMediator;
import dittner.testmyself.deutsch.view.test.form.*;

public class SearchNoteFormMediator extends SFMediator {

	public function SearchNoteFormMediator() {}

	[Inject]
	public var view:NoteForm;

	private var selectedFoundNote:FoundNote;
	private var activeEditorMediator:NoteEditorMediator;
	private var activeRemoverMediator:NoteRemoverMediator;

	override protected function activate():void {
		addListener(NoteMsg.FORM_DEACTIVATED_NOTIFICATION, hideNoteForm);
	}

	public function startEditing(fnote:FoundNote):void {
		selectedFoundNote = fnote;
		if (selectedFoundNote && selectedFoundNote.note) {
			view.moduleName = selectedFoundNote.isExample ? ModuleName.LESSON : selectedFoundNote.moduleName;
			registerEditorMediator(selectedFoundNote.moduleName);
			sendNotification(NoteMsg.NOTE_SELECTED_NOTIFICATION, selectedFoundNote.note);
			sendNotification(NoteMsg.TOOL_ACTION_SELECTED_NOTIFICATION, ToolAction.EDIT);
		}
	}

	private function registerEditorMediator(moduleName:String):void {
		if (activeEditorMediator) {
			unregisterMediator(activeEditorMediator);
		}
		if (selectedFoundNote.isExample) {
			activeEditorMediator = new ExampleEditorMediator();
		}
		else {
			switch (moduleName) {
				case ModuleName.LESSON:
					activeEditorMediator = new LessonEditorMediator();
					break;
				case ModuleName.PHRASE:
					activeEditorMediator = new PhraseEditorMediator();
					break;
				case ModuleName.WORD:
					activeEditorMediator = new WordEditorMediator();
					break;
				case ModuleName.VERB:
					activeEditorMediator = new VerbEditorMediator();
					break;
				default :
					throw new Error("Unknown module name: " + moduleName);
			}
		}

		registerMediator(view, activeEditorMediator);
	}

	public function startRemoving(fnote:FoundNote):void {
		selectedFoundNote = fnote;

		if (selectedFoundNote && selectedFoundNote.note) {
			view.moduleName = selectedFoundNote.isExample ? ModuleName.LESSON : selectedFoundNote.moduleName;
			registerRemoverMediator(selectedFoundNote.moduleName);
			sendNotification(NoteMsg.NOTE_SELECTED_NOTIFICATION, selectedFoundNote.note);
			sendNotification(NoteMsg.TOOL_ACTION_SELECTED_NOTIFICATION, ToolAction.REMOVE);
		}
	}

	private function registerRemoverMediator(moduleName:String):void {
		if (activeRemoverMediator) {
			unregisterMediator(activeRemoverMediator);
		}

		activeRemoverMediator = selectedFoundNote.isExample ? new ExampleRemoverMediator() : new NoteRemoverMediator();
		registerMediator(view, activeRemoverMediator);
	}

	private function hideNoteForm(params:* = null):void {
		sendGlobalNotification(SearchMsg.HIDE_NOTE_FORM);
	}

	override protected function deactivate():void {
		if (view.isOpen()) {
			view.close();
			sendGlobalNotification(SearchMsg.HIDE_NOTE_FORM);
		}
	}

}
}