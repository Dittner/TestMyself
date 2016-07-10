package de.dittner.testmyself.ui.view.dictionary.note.list {
import de.dittner.async.IAsyncOperation;
import de.dittner.satelliteFlight.mediator.SFMediator;
import de.dittner.satelliteFlight.message.RequestMessage;
import de.dittner.testmyself.backend.message.NoteMsg;
import de.dittner.testmyself.model.domain.note.INote;
import de.dittner.testmyself.ui.common.list.SelectableDataGroup;

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
		sendRequest(NoteMsg.GET_EXAMPLES, new RequestMessage(onExamplesLoaded, note.id));
	}

	protected function onExamplesLoaded(op:IAsyncOperation):void {
		if (op.result is Array && op.result.length > 0) {
			view.dataProvider = new ArrayCollection(op.result as Array);
		}
		else {
			hideList();
		}
	}

	private function hideList():void {
		view.dataProvider = null;
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