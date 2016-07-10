package de.dittner.testmyself.ui.view.search {
import de.dittner.satelliteFlight.mediator.SFMediator;
import de.dittner.testmyself.backend.message.SearchMsg;
import de.dittner.testmyself.model.search.FoundNote;
import de.dittner.testmyself.ui.common.list.SelectableDataGroup;

import flash.events.Event;

import mx.collections.ArrayCollection;

public class SearchResultListMediator extends SFMediator {

	[Inject]
	public var view:SelectableDataGroup;

	override protected function activate():void {
		view.addEventListener(SelectableDataGroup.SELECTED, noteRenDataSelectedHandler);
		addListener(SearchMsg.FOUND_NOTES_LOADED_NOTIFICATION, onNotesLoaded);
	}

	private function noteRenDataSelectedHandler(event:Event):void {
		sendNotification(SearchMsg.SELECTED_NOTE_NOTIFICATION, view.selectedItem as FoundNote);
	}

	private function onNotesLoaded(fnotes:Array):void {
		view.dataProvider = new ArrayCollection(fnotes);
		view.selectedItem = null;
		sendNotification(SearchMsg.SELECTED_NOTE_NOTIFICATION, null);
	}

	override protected function deactivate():void {
		view.removeEventListener(SelectableDataGroup.SELECTED, noteRenDataSelectedHandler);
		view.dataProvider = null;
	}

}
}