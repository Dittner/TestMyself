package dittner.testmyself.deutsch.view.search {
import dittner.satelliteFlight.command.CommandResult;
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.core.message.SearchMsg;
import dittner.testmyself.deutsch.model.ModuleName;
import dittner.testmyself.deutsch.model.search.SearchSpec;

import flash.events.MouseEvent;

import mx.events.FlexEvent;

public class SearchBoardMediator extends SFMediator {

	[Inject]
	public var view:SearchBoard;

	private var searchQueue:Array = [];
	private var foundNotes:Array = [];

	override protected function activate():void {
		view.applyBtn.addEventListener(MouseEvent.CLICK, startSearch);
		view.searchInput.addEventListener(FlexEvent.ENTER, startSearch);
		if (view.stage) view.stage.focus = view.searchInput;
	}

	public function startSearch(event:* = null):void {
		if (view.searchInput.text.length <= 1) return;

		searchQueue.length = 0;
		foundNotes.length = 0;

		if (view.wordBox.selected) searchQueue.push(new Search(ModuleName.WORD, false));
		if (view.verbBox.selected) searchQueue.push(new Search(ModuleName.VERB, false));
		if (view.phraseBox.selected) searchQueue.push(new Search(ModuleName.PHRASE, false));
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
			searchSpec.needDescription = view.descriptionSearchRadioBtn.selected;
			sendRequestTo(search.moduleName, NoteMsg.SEARCH_NOTES, new RequestMessage(foundNotesLoaded, null, searchSpec));
		}
		else {
			sendNotification(SearchMsg.FOUND_NOTES_UPDATED_NOTIFICATION, foundNotes);
		}
	}

	private function foundNotesLoaded(res:CommandResult):void {
		if (res.data && res.data.length > 0) foundNotes = foundNotes.concat(res.data as Array);
		findNext();
	}

	override protected function deactivate():void {
		view.applyBtn.removeEventListener(MouseEvent.CLICK, startSearch);
		view.searchInput.removeEventListener(FlexEvent.ENTER, startSearch);
		view.searchInput.text = "";
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