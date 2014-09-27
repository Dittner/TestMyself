package dittner.testmyself.deutsch.view.test.common {
import dittner.testmyself.core.model.note.INote;
import dittner.testmyself.core.model.test.TestTask;

public class TestRendererData {
	public function TestRendererData(note:INote, task:TestTask, translationInverted:Boolean = false) {
		_note = note;
		_task = task;
		_translationInverted = translationInverted;
	}

	private var _note:INote;
	public function get note():INote {return _note;}

	private var _task:TestTask;
	public function get task():TestTask {return _task;}

	private var _translationInverted:Boolean = false;
	public function get translationInverted():Boolean {return _translationInverted;}

}
}
