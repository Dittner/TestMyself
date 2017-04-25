package de.dittner.testmyself.ui.common.view {
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.tag.Tag;

public class NoteFormViewInfo extends ViewInfo {
	public function NoteFormViewInfo(viewID:String = "") {
		super(viewID);
	}

	public var formMode:String = "";
	public var filter:Tag;
	public var note:Note;
	public var callback:IAsyncOperation;
}
}