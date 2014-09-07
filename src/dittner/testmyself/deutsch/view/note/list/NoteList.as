package dittner.testmyself.deutsch.view.note.list {
import dittner.testmyself.deutsch.utils.pendingInvalidation.invalidateOf;
import dittner.testmyself.deutsch.view.common.list.SelectableDataGroup;
import dittner.testmyself.deutsch.view.common.renderer.IFlexibleRenderer;

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