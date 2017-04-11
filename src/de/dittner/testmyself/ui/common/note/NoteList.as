package de.dittner.testmyself.ui.common.note {
import de.dittner.async.utils.invalidateOf;
import de.dittner.testmyself.ui.common.list.SelectableDataGroup;
import de.dittner.testmyself.ui.common.renderer.INoteRenderer;

import flash.events.Event;

public class NoteList extends SelectableDataGroup {
	public function NoteList() {
		super();
	}

	override public function set percentWidth(value:Number):void {
		super.percentWidth = value;
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
			invalidateRenderView();
			dispatchEvent(new Event("renderOptionsChanged"));
		}
	}

	public function invalidateRenderView():void {
		invalidateOf(validateRenderView);
	}

	private function validateRenderView():void {
		for (var i:int = 0; i < numElements; i++) {
			var renderer:INoteRenderer = getElementAt(i) as INoteRenderer;
			if (renderer) renderer.invalidatePropertiesSizeAndDisplayList();
		}
	}

	override protected function notifySelectedItemChanged():void {
		super.notifySelectedItemChanged();
		if (selectedItem) invalidateOf(ensureSelectedItemIsVisible);
	}
}
}
