package dittner.testmyself.deutsch.view.dictionary.note.list {
import dittner.satelliteFlight.command.CommandResult;
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.core.model.note.INote;
import dittner.testmyself.deutsch.view.common.list.SelectableDataGroup;

import flash.events.Event;

import mx.collections.ArrayCollection;

public class ExampleListMediator extends SFMediator {

	[Inject]
	public var view:ExampleList;

	override protected function activate():void {
		view.dataGroup.addEventListener(SelectableDataGroup.SELECTED, exampleSelectedHandler);
		addListener(NoteMsg.NOTE_SELECTED_NOTIFICATION, noteSelectedHandler);
	}

	private function noteSelectedHandler(note:INote):void {
		if (note) loadExamples(note);
		else hideList();
	}

	private function loadExamples(note:INote):void {
		sendRequest(NoteMsg.GET_EXAMPLES, new RequestMessage(onExamplesLoaded, null, note.id));
	}

	protected function onExamplesLoaded(res:CommandResult):void {
		if (res.data is Array && res.data.length > 0) {
			view.dataProvider = new ArrayCollection(res.data as Array);
			view.visible = view.includeInLayout = true;
		}
		else {
			hideList();
		}
	}

	private function hideList():void {
		view.dataProvider = null;
		view.visible = view.includeInLayout = false;
	}

	private function exampleSelectedHandler(event:Event):void {
		sendNotification(NoteMsg.EXAMPLE_SELECTED_NOTIFICATION, view.dataGroup.selectedItem);
	}

	override protected function deactivate():void {
		hideList();
		view.dataGroup.removeEventListener(SelectableDataGroup.SELECTED, exampleSelectedHandler);
	}
}
}