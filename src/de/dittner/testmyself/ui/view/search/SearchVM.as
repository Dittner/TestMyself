package de.dittner.testmyself.ui.view.search {
import de.dittner.testmyself.model.domain.language.LanguageID;
import de.dittner.testmyself.model.domain.vocabulary.VocabularyID;
import de.dittner.testmyself.ui.common.menu.ViewID;
import de.dittner.testmyself.ui.common.page.SearchPage;
import de.dittner.testmyself.ui.common.view.ViewInfo;
import de.dittner.testmyself.ui.common.view.ViewModel;

import flash.events.Event;

public class SearchVM extends ViewModel {

	public function SearchVM() {
		super();
	}

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

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override public function viewActivated(viewInfo:ViewInfo):void {
		super.viewActivated(viewInfo);
		setPage(appModel.getSearchPage());
		page.countAllNotes = true;
		if (page.searchText) page.reload();
	}

	public function loadPage(searchText:String, loadExamples:Boolean, loadWords:Boolean, loadVerbs:Boolean, loadLessons:Boolean):void {
		page.countAllNotes = page.searchText != searchText;
		page.originalSearchText = searchText;
		page.searchText = searchText.replace(/(ё)/gi, "е").replace(/(Ё)/gi, "Е");
		page.loadExamples = loadExamples;
		page.vocabularyIDs = [];

		if (page.lang.id == LanguageID.DE) {
			if (loadWords) page.vocabularyIDs.push(VocabularyID.DE_WORD);
			if (loadVerbs) page.vocabularyIDs.push(VocabularyID.DE_VERB);
			if (loadLessons) page.vocabularyIDs.push(VocabularyID.DE_LESSON);
		}
		else if (page.lang.id == LanguageID.EN) {
			if (loadWords) page.vocabularyIDs.push(VocabularyID.EN_WORD);
			if (loadVerbs) page.vocabularyIDs.push(VocabularyID.EN_VERB);
			if (loadLessons) page.vocabularyIDs.push(VocabularyID.EN_LESSON);
		}

		page.reload();
	}

	public function showNote(selectedNoteIndex:int):void {
		if (page && selectedNoteIndex != -1) {
			var info:ViewInfo = new ViewInfo();
			info.viewID = ViewID.NOTE_VIEW;
			info.menuViewID = viewInfo.menuViewID;
			info.page = page;
			info.page.selectedItemIndex = selectedNoteIndex;
			mainVM.viewNavigator.navigate(info);
		}
	}

	override protected function deactivate():void {}

}
}