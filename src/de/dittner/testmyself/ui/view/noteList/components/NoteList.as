package de.dittner.testmyself.ui.view.noteList.components {
import de.dittner.async.utils.invalidateOf;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.ui.common.list.SelectableDataGroup;
import de.dittner.testmyself.ui.common.renderer.IFlexibleRenderer;

import flash.events.Event;

public class NoteList extends SelectableDataGroup {
	public function NoteList() {
		super();
	}

	//--------------------------------------
	//  selectedNote
	//--------------------------------------
	[Bindable("selectedItemChange")]
	public function get selectedNote():Note {return selectedItem as Note;}
	public function set selectedNote(value:Note):void {
		selectedItem = value;
	}

	//--------------------------------------
	//  pageLayout
	//--------------------------------------
	private var _pageLayout:PageLayout = new PageLayout();
	[Bindable("pageLayoutChanged")]
	public function get pageLayout():PageLayout {return _pageLayout;}
	public function set pageLayout(value:PageLayout):void {
		if (_pageLayout != value) {
			_pageLayout = value;
			invalidatePageLayout();
			dispatchEvent(new Event("pageLayoutChanged"));
		}
	}

	public function invalidatePageLayout():void {
		invalidateOf(validateLayout);
	}

	private function validateLayout():void {
		for (var i:int = 0; i < numElements; i++) {
			var renderer:IFlexibleRenderer = getElementAt(i) as IFlexibleRenderer;
			if (renderer) renderer.invalidateLayout();
		}
	}

	override protected function notifySelectedItemChanged():void {
		super.notifySelectedItemChanged();
		if (selectedNote) invalidateOf(ensureSelectedItemIsVisible);
	}
}
}
