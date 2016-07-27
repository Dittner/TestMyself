package de.dittner.testmyself.ui.view.search {
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.model.AppModel;
import de.dittner.testmyself.model.domain.language.Language;
import de.dittner.testmyself.model.domain.note.INote;
import de.dittner.testmyself.model.domain.vocabulary.VocabularyID;
import de.dittner.testmyself.ui.common.page.SearchPageInfo;
import de.dittner.testmyself.ui.common.view.ViewInfo;
import de.dittner.testmyself.ui.common.view.ViewModel;

import flash.events.Event;

public class SearchVM extends ViewModel {

	public function SearchVM() {
		super();
	}

	[Inject]
	public var storage:Storage;

	[Inject]
	public var appModel:AppModel;

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
	private var _page:SearchPageInfo;
	[Bindable("pageChanged")]
	public function get page():SearchPageInfo {return _page;}
	public function set page(value:SearchPageInfo):void {
		if (_page != value) {
			_page = value;
			dispatchEvent(new Event("pageChanged"));
		}
	}

	//--------------------------------------
	//  selectedNote
	//--------------------------------------
	private var _selectedNote:INote;
	[Bindable("selectedNoteChanged")]
	public function get selectedNote():INote {return _selectedNote;}
	public function set selectedNote(value:INote):void {
		if (_selectedNote != value) {
			_selectedNote = value;
			dispatchEvent(new Event("selectedNoteChanged"));
		}
	}

	//--------------------------------------
	//  selectedExample
	//--------------------------------------
	private var _selectedExample:INote;
	[Bindable("selectedExampleChanged")]
	public function get selectedExample():INote {return _selectedExample;}
	public function set selectedExample(value:INote):void {
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

	override public function viewActivated(info:ViewInfo):void {
		super.viewActivated(info);
		selectedLang = appModel.selectedLanguage;
		page = new SearchPageInfo();
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