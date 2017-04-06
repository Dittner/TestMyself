package de.dittner.testmyself.ui.common.note {
import de.dittner.async.utils.invalidateOf;
import de.dittner.testmyself.ui.common.list.SelectableDataGroup;
import de.dittner.testmyself.ui.common.renderer.IFlexibleRenderer;

import flash.events.Event;

public class NoteList extends SelectableDataGroup {
	public function NoteList() {
		super();
	}

	//--------------------------------------
	//  renderOptions
	//--------------------------------------
	private var _renderOptions:NoteRenderOptions = new NoteRenderOptions();
	[Bindable("renderOptionsChanged")]
	public function get renderOptions():NoteRenderOptions {return _renderOptions;}
	public function set renderOptions(value:NoteRenderOptions):void {
		if (_renderOptions != value) {
			_renderOptions = value;
			invalidateRenderOptions();
			dispatchEvent(new Event("renderOptionsChanged"));
		}
	}

	public function invalidateRenderOptions():void {
		invalidateOf(validateRenderOptions);
	}

	private function validateRenderOptions():void {
		for (var i:int = 0; i < numElements; i++) {
			var renderer:IFlexibleRenderer = getElementAt(i) as IFlexibleRenderer;
			if (renderer) renderer.invalidateOptions();
		}
	}

	override protected function notifySelectedItemChanged():void {
		super.notifySelectedItemChanged();
		if (selectedItem) invalidateOf(ensureSelectedItemIsVisible);
	}
}
}
