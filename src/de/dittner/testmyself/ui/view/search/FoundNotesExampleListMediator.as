package de.dittner.testmyself.ui.view.search {
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.message.NoteMsg;
import de.dittner.testmyself.backend.message.SearchMsg;
import de.dittner.testmyself.model.search.FoundNote;
import de.dittner.testmyself.ui.common.list.SelectableDataGroup;
import de.dittner.testmyself.ui.view.noteList.common.ExampleList;

import flash.events.Event;

import mx.collections.ArrayCollection;

public class FoundNotesExampleListMediator extends SFMediator {

	[Inject]
	public var view:ExampleList;

	override protected function activate():void {
		view.dataGroup.addEventListener(SelectableDataGroup.SELECTED, exampleSelectedHandler);
		addListener(SearchMsg.SELECTED_NOTE_NOTIFICATION, noteSelectedHandler);
	}

	private function noteSelectedHandler(fnote:FoundNote):void {
		if (fnote && (fnote.note is IWord || fnote.note is IVerb)) loadExamples(fnote);
		else hideList();
	}

	private function loadExamples(fnote:FoundNote):void {
		sendRequestTo(fnote.moduleName, NoteMsg.GET_EXAMPLES, new RequestMessage(onExamplesLoaded, fnote.note.id));
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