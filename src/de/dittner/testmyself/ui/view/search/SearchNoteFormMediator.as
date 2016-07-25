package de.dittner.testmyself.ui.view.search {
import de.dittner.testmyself.backend.message.NoteMsg;
import de.dittner.testmyself.backend.message.SearchMsg;
import de.dittner.testmyself.model.search.FoundNote;
import de.dittner.testmyself.ui.view.noteList.common.form.NoteForm;
import de.dittner.testmyself.ui.view.noteList.common.toolbar.ToolAction;
import de.dittner.testmyself.ui.view.test.form.*;

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
			view.moduleName = selectedFoundNote.isExample ? "" : selectedFoundNote.moduleName;
			registerEditorMediator(selectedFoundNote.moduleName);
			sendNotification(NoteMsg.NOTE_SELECTED_NOTIFICATION, selectedFoundNote.note);
			sendNotification(NoteMsg.TOOL_ACTION_SELECTED_NOTIFICATION, ToolAction.EDIT_NOTE);
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
			view.moduleName = selectedFoundNote.isExample ? "" : selectedFoundNote.moduleName;
			registerRemoverMediator(selectedFoundNote.moduleName);
			sendNotification(NoteMsg.NOTE_SELECTED_NOTIFICATION, selectedFoundNote.note);
			sendNotification(NoteMsg.TOOL_ACTION_SELECTED_NOTIFICATION, ToolAction.REMOVE_NOTE);
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
		if (view.isOpen) {
			view.close();
			sendGlobalNotification(SearchMsg.HIDE_NOTE_FORM);
		}
	}

}
}