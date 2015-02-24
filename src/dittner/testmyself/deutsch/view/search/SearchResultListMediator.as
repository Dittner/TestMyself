package dittner.testmyself.deutsch.view.search {
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.testmyself.core.message.SearchMsg;
import dittner.testmyself.deutsch.model.search.FoundNote;
import dittner.testmyself.deutsch.view.common.list.SelectableDataGroup;

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