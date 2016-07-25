package de.dittner.testmyself.ui.view.test.form {
import de.dittner.testmyself.backend.message.NoteMsg;
import de.dittner.testmyself.backend.message.TestMsg;
import de.dittner.testmyself.model.domain.note.INote;
import de.dittner.testmyself.model.domain.test.Test;
import de.dittner.testmyself.ui.common.toobar.ToolAction;
import de.dittner.testmyself.ui.view.vocabulary.lesson.form.LessonEditorMediator;
import de.dittner.testmyself.ui.view.vocabulary.note.form.NoteEditorMediator;
import de.dittner.testmyself.ui.view.vocabulary.note.form.NoteForm;
import de.dittner.testmyself.ui.view.vocabulary.note.form.NoteRemoverMediator;
import de.dittner.testmyself.ui.view.vocabulary.verb.form.VerbEditorMediator;
import de.dittner.testmyself.ui.view.vocabulary.word.form.WordEditorMediator;

public class TestingNoteFormMediator extends SFMediator {

	public function TestingNoteFormMediator() {}

	[Inject]
	public var view:NoteForm;

	public var selectedTestInfo:Test;
	private var testingNote:INote;
	private var activeEditorMediator:NoteEditorMediator;
	private var activeRemoverMediator:NoteRemoverMediator;

	override protected function activate():void {
		addListenerTo(ModuleName.ROOT, TestMsg.TESTING_NOTE_SELECTED, testingNoteSelected);
		addListener(NoteMsg.FORM_DEACTIVATED_NOTIFICATION, hideNoteForm);
	}

	private function testingNoteSelected(note:INote):void {
		testingNote = note;
	}

	public function startEditing():void {
		if (testingNote) {
			view.moduleName = selectedTestInfo.useExamples ? "" : selectedTestInfo.moduleName;
			registerEditorMediator(selectedTestInfo.moduleName);
			sendNotification(NoteMsg.NOTE_SELECTED_NOTIFICATION, testingNote);
			sendNotification(NoteMsg.TOOL_ACTION_SELECTED_NOTIFICATION, ToolAction.EDIT);
		}
	}

	public function startRemoving():void {
		if (testingNote) {
			view.moduleName = selectedTestInfo.useExamples ? "" : selectedTestInfo.moduleName;
			registerRemoverMediator(selectedTestInfo.moduleName);
			sendNotification(NoteMsg.NOTE_SELECTED_NOTIFICATION, testingNote);
			sendNotification(NoteMsg.TOOL_ACTION_SELECTED_NOTIFICATION, ToolAction.REMOVE);
		}
	}

	private function registerEditorMediator(moduleName:String):void {
		if (activeEditorMediator) {
			unregisterMediator(activeEditorMediator);
		}
		if (selectedTestInfo.useExamples) {
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

	private function registerRemoverMediator(moduleName:String):void {
		if (activeRemoverMediator) {
			unregisterMediator(activeRemoverMediator);
		}

		activeRemoverMediator = selectedTestInfo.useExamples ? new ExampleRemoverMediator() : new NoteRemoverMediator();
		registerMediator(view, activeRemoverMediator);
	}

	private function hideNoteForm(params:* = null):void {
		sendGlobalNotification(TestMsg.HIDE_NOTE_FORM);
	}

	override protected function deactivate():void {
		if (view.isOpen) {
			view.close();
			sendGlobalNotification(TestMsg.HIDE_NOTE_FORM);
		}
	}

}
}