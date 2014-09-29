package dittner.testmyself.deutsch.view.dictionary.note.list {
import dittner.testmyself.core.model.note.INote;
import dittner.testmyself.deutsch.view.dictionary.common.*;

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
