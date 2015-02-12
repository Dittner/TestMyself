package dittner.testmyself.deutsch.view.search {
import dittner.satelliteFlight.command.CommandResult;
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.core.message.SearchMsg;
import dittner.testmyself.deutsch.model.domain.verb.IVerb;
import dittner.testmyself.deutsch.model.domain.word.IWord;
import dittner.testmyself.deutsch.model.search.FoundNote;
import dittner.testmyself.deutsch.view.common.list.SelectableDataGroup;
import dittner.testmyself.deutsch.view.dictionary.note.list.*;

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
		sendRequestTo(fnote.moduleName, NoteMsg.GET_EXAMPLES, new RequestMessage(onExamplesLoaded, null, fnote.note.id));
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