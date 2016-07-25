package de.dittner.testmyself.ui.view.vocabulary.note.list {
import de.dittner.testmyself.model.domain.note.INote;
import de.dittner.testmyself.ui.view.vocabulary.common.*;

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
