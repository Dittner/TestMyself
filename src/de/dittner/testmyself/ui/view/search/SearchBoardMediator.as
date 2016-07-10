package de.dittner.testmyself.ui.view.search {
import de.dittner.async.IAsyncOperation;
import de.dittner.satelliteFlight.mediator.SFMediator;
import de.dittner.satelliteFlight.message.RequestMessage;
import de.dittner.testmyself.backend.message.NoteMsg;
import de.dittner.testmyself.backend.message.SearchMsg;
import de.dittner.testmyself.model.AppConfig;
import de.dittner.testmyself.model.ModuleName;
import de.dittner.testmyself.model.search.SearchSpec;

import flash.desktop.NativeApplication;
import flash.events.Event;
import flash.events.MouseEvent;

import mx.events.FlexEvent;

public class SearchBoardMediator extends SFMediator {

	[Inject]
	public var view:SearchBoard;

	private var searchQueue:Array = [];
	private var foundNotes:Array = [];
	private static var history:TextHistory = new TextHistory();

	override protected function activate():void {
		view.history = history;
		updateSearchInput();
		view.searchInput.selectAll();
		view.applyBtn.addEventListener(MouseEvent.CLICK, startSearch);
		view.searchInput.addEventListener(FlexEvent.ENTER, startSearch);
		view.undoBtn.addEventListener(MouseEvent.CLICK, undoSearch);
		view.redoBtn.addEventListener(MouseEvent.CLICK, redoSearch);
		if (view.stage && AppConfig.isDesktop) view.stage.focus = view.searchInput;
		NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, nativeApplication_activateHandler);
	}

	private function nativeApplication_activateHandler(event:Event):void {
		if (view.stage && AppConfig.isDesktop) view.stage.focus = view.searchInput;
	}

	public function startSearch(event:* = null):void {
		if (view.searchInput.text.length <= 1) return;

		FoundNoteRenderer.searchingText = view.searchInput.text;

		if (history.row != view.searchInput.text)
			history.push(view.searchInput.text);

		searchQueue.length = 0;
		foundNotes.length = 0;
		updateSearchInput();

		if (view.wordBox.selected) searchQueue.push(new Search(ModuleName.WORD, false));
		if (view.verbBox.selected) searchQueue.push(new Search(ModuleName.VERB, false));
		if (view.lessonBox.selected) searchQueue.push(new Search(ModuleName.LESSON, false));
		if (view.wordExamplesBox.selected) searchQueue.push(new Search(ModuleName.WORD, true));
		if (view.verbExamplesBox.selected) searchQueue.push(new Search(ModuleName.VERB, true));

		findNext();
	}

	private function findNext():void {
		if (searchQueue.length) {
			var search:Search = searchQueue.shift() as Search;
			var searchSpec:SearchSpec = new SearchSpec();
			searchSpec.searchText = view.searchInput.text;
			searchSpec.needExample = search.needExample;
			sendRequestTo(search.moduleName, NoteMsg.SEARCH_NOTES, new RequestMessage(foundNotesLoaded, searchSpec));
		}
		else {
			sendNotification(SearchMsg.FOUND_NOTES_UPDATED_NOTIFICATION, foundNotes);
		}
	}

	private function foundNotesLoaded(op:IAsyncOperation):void {
		if (op.result && op.result.length > 0) foundNotes = foundNotes.concat(op.result as Array);
		findNext();
	}

	private function undoSearch(e:MouseEvent):void {
		history.undo();
		updateSearchInput();
	}

	private function redoSearch(e:MouseEvent):void {
		history.redo();
		updateSearchInput();
	}

	private function updateSearchInput():void {
		view.searchInput.text = history.row;
		if (AppConfig.isDesktop) view.stage.focus = view.searchInput;
		view.searchInput.selectAll();
	}

	override protected function deactivate():void {
		view.applyBtn.removeEventListener(MouseEvent.CLICK, startSearch);
		view.searchInput.removeEventListener(FlexEvent.ENTER, startSearch);
		view.undoBtn.removeEventListener(MouseEvent.CLICK, undoSearch);
		view.redoBtn.removeEventListener(MouseEvent.CLICK, redoSearch);
		view.searchInput.text = "";
		NativeApplication.nativeApplication.removeEventListener(Event.ACTIVATE, nativeApplication_activateHandler);
	}

}
}
class Search {
	public function Search(moduleName:String, needExample:Boolean):void {
		this.moduleName = moduleName;
		this.needExample = needExample;
	}

	public var moduleName:String;
	public var needExample:Boolean;
}