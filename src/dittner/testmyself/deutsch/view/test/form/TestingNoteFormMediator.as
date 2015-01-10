package dittner.testmyself.deutsch.view.test.form {
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.core.message.TestMsg;
import dittner.testmyself.core.model.note.INote;
import dittner.testmyself.core.model.test.TestInfo;
import dittner.testmyself.deutsch.model.ModuleName;
import dittner.testmyself.deutsch.view.common.toobar.ToolAction;
import dittner.testmyself.deutsch.view.dictionary.lesson.form.LessonEditorMediator;
import dittner.testmyself.deutsch.view.dictionary.note.form.NoteEditorMediator;
import dittner.testmyself.deutsch.view.dictionary.note.form.NoteForm;
import dittner.testmyself.deutsch.view.dictionary.phrase.form.PhraseEditorMediator;
import dittner.testmyself.deutsch.view.dictionary.verb.form.VerbEditorMediator;
import dittner.testmyself.deutsch.view.dictionary.word.form.WordEditorMediator;

public class TestingNoteFormMediator extends SFMediator {

	public function TestingNoteFormMediator() {}

	[Inject]
	public var view:NoteForm;

	public var selectedTestInfo:TestInfo;
	private var testingNote:INote;
	private var activeEditorMediator:NoteEditorMediator;

	override protected function activate():void {
		addListenerTo(ModuleName.ROOT, TestMsg.TESTING_NOTE_SELECTED, testingNoteSelected);
		addListener(NoteMsg.FORM_DEACTIVATED_NOTIFICATION, hideNoteForm);
	}

	private function testingNoteSelected(note:INote):void {
		testingNote = note;
	}

	public function startEditing():void {
		if (testingNote) {
			view.moduleName = selectedTestInfo.useNoteExample ? ModuleName.LESSON : selectedTestInfo.moduleName;
			registerEditorMediator(selectedTestInfo.moduleName);
			sendNotification(NoteMsg.NOTE_SELECTED_NOTIFICATION, testingNote);
			sendNotification(NoteMsg.TOOL_ACTION_SELECTED_NOTIFICATION, ToolAction.EDIT);
		}
	}

	private function registerEditorMediator(moduleName:String):void {
		if (activeEditorMediator) {
			unregisterMediator(activeEditorMediator);
		}
		if (selectedTestInfo.useNoteExample) {
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

	private function hideNoteForm(params:* = null):void {
		sendGlobalNotification(TestMsg.HIDE_NOTE_FORM);
	}

	override protected function deactivate():void {
		if (view.isOpen()) {
			view.close();
			sendGlobalNotification(TestMsg.HIDE_NOTE_FORM);
		}
	}

}
}