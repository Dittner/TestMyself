package de.dittner.testmyself.ui.view.vocabulary.note.list {
import de.dittner.async.utils.invalidateOf;
import de.dittner.testmyself.ui.common.list.SelectableDataGroup;
import de.dittner.testmyself.ui.common.renderer.IFlexibleRenderer;

public class NoteList extends SelectableDataGroup {
	public function NoteList() {
		super();
	}

	public function invalidateLayout():void {
		invalidateOf(validateLayout);
	}

	private function validateLayout():void {
		for (var i:int = 0; i < numElements; i++) {
			var renderer:IFlexibleRenderer = getElementAt(i) as IFlexibleRenderer;
			if (renderer) renderer.invalidateLayout();
		}
	}
}
}
