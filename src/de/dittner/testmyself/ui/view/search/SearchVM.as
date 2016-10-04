package de.dittner.testmyself.ui.view.search {
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.model.domain.language.Language;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.vocabulary.VocabularyID;
import de.dittner.testmyself.ui.common.page.SearchPage;
import de.dittner.testmyself.ui.common.view.ViewModel;

import flash.events.Event;

public class SearchVM extends ViewModel {

	public function SearchVM() {
		super();
	}

	[Inject]
	public var storage:Storage;

	[Bindable]
	public var selectedLang:Language;

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	//--------------------------------------
	//  page
	//--------------------------------------
	private var _page:SearchPage;
	[Bindable("pageChanged")]
	public function get page():SearchPage {return _page;}
	private function setPage(value:SearchPage):void {
		if (_page != value) {
			_page = value;
			dispatchEvent(new Event("pageChanged"));
		}
	}

	//--------------------------------------
	//  selectedNoteTags
	//--------------------------------------
	private var _selectedNoteTags:String = "";
	[Bindable("selectedNoteChanged")]
	public function get selectedNoteTags():String {return _selectedNoteTags;}

	//--------------------------------------
	//  selectedNote
	//--------------------------------------
	private var _selectedNote:Note;
	[Bindable("selectedNoteChanged")]
	public function get selectedNote():Note {return _selectedNote;}
	public function set selectedNote(value:Note):void {
		if (_selectedNote != value) {
			_selectedNote = value;
			_selectedNoteTags = selectedNote ? selectedNote.tagsToStr() : "";
			dispatchEvent(new Event("selectedNoteChanged"));
		}
	}

	//--------------------------------------
	//  selectedExample
	//--------------------------------------
	private var _selectedExample:Note;
	[Bindable("selectedExampleChanged")]
	public function get selectedExample():Note {return _selectedExample;}
	public function set selectedExample(value:Note):void {
		if (_selectedExample != value) {
			_selectedExample = value;
			dispatchEvent(new Event("selectedExampleChanged"));
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override public function viewActivated(viewID:String):void {
		super.viewActivated(viewID);
		viewTitle = "SUCHE";
		selectedLang = appModel.selectedLanguage;
		setPage(new SearchPage());
	}

	public function loadPage(searchText:String, loadExamples:Boolean, loadWords:Boolean, loadVerbs:Boolean, loadLessons:Boolean):void {
		selectedNote = null;
		selectedExample = null;

		page.lang = selectedLang;
		page.searchText = searchText;
		page.loadExamples = loadExamples;
		page.vocabularyIDs = [];
		if (loadWords) page.vocabularyIDs.push(VocabularyID.DE_WORD);
		if (loadVerbs) page.vocabularyIDs.push(VocabularyID.DE_VERB);
		if (loadLessons) page.vocabularyIDs.push(VocabularyID.DE_LESSON);

		storage.searchNotes(page);
	}

	override protected function deactivate():void {}

}
}