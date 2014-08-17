package dittner.testmyself.view.phrase.list {
import dittner.testmyself.utils.pendingInvalidation.invalidateOf;
import dittner.testmyself.view.common.list.SelectableDataGroup;
import dittner.testmyself.view.common.renderer.IFlexibleRenderer;

public class TransUnitList extends SelectableDataGroup {
	public function TransUnitList() {
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
