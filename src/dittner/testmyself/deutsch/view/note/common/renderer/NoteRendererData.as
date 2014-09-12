package dittner.testmyself.deutsch.view.note.common.renderer {
import dittner.testmyself.core.model.note.INote;
import dittner.testmyself.deutsch.view.note.common.*;

public class NoteRendererData {
	public function NoteRendererData(note:INote, layout:PageLayoutInfo) {
		_note = note;
		_layout = layout;
	}

	private var _note:INote;
	public function get note():INote {return _note;}

	private var _layout:PageLayoutInfo;
	public function get layout():PageLayoutInfo {return _layout;}

}
}
