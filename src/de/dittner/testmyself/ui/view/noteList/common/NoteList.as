package de.dittner.testmyself.ui.view.noteList.common {
import de.dittner.async.utils.invalidateOf;
import de.dittner.testmyself.ui.common.list.SelectableDataGroup;
import de.dittner.testmyself.ui.common.renderer.IFlexibleRenderer;

import flash.events.Event;

public class NoteList extends SelectableDataGroup {
	public function NoteList() {
		super();
	}

	//--------------------------------------
	//  pageLayout
	//--------------------------------------
	private var _pageLayout:PageLayout = new PageLayout();
	[Bindable("pageLayoutChanged")]
	public function get pageLayout():PageLayout {return _pageLayout;}
	public function set pageLayout(value:PageLayout):void {
		_pageLayout = value;
		invalidateOf(validateLayout);
		dispatchEvent(new Event("pageLayoutChanged"));
	}

	private function validateLayout():void {
		for (var i:int = 0; i < numElements; i++) {
			var renderer:IFlexibleRenderer = getElementAt(i) as IFlexibleRenderer;
			if (renderer) renderer.invalidateLayout();
		}
	}
}
}
