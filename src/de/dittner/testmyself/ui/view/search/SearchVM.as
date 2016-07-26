package de.dittner.testmyself.ui.view.search {
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.model.AppModel;
import de.dittner.testmyself.model.domain.language.Language;
import de.dittner.testmyself.model.domain.vocabulary.VocabularyID;
import de.dittner.testmyself.ui.common.page.SearchPageInfo;
import de.dittner.testmyself.ui.common.view.ViewInfo;
import de.dittner.testmyself.ui.common.view.ViewModel;

import flash.events.Event;

import mx.collections.ArrayCollection;

public class SearchVM extends ViewModel {

	public function SearchVM() {
		super();
	}

	[Inject]
	public var sqlStorage:SQLStorage;

	[Inject]
	public var appModel:AppModel;

	//----------------------------------------------------------------------------------------------
	//
	//  Variables
	//
	//----------------------------------------------------------------------------------------------

	[Bindable]
	public var selectedLang:Language;

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	//--------------------------------------
	//  noteColl
	//--------------------------------------
	private var _noteColl:ArrayCollection;
	[Bindable("noteCollChanged")]
	public function get noteColl():ArrayCollection {return _noteColl;}
	public function set noteColl(value:ArrayCollection):void {
		if (_noteColl != value) {
			_noteColl = value;
			dispatchEvent(new Event("noteCollChanged"));
		}
	}

	//--------------------------------------
	//  pageSize
	//--------------------------------------
	public function get pageSize():uint {return 10;}

	//--------------------------------------
	//  curPageNum
	//--------------------------------------
	private var _pageNum:uint = 0;
	[Bindable("curPageNumChanged")]
	public function get pageNum():uint {return _pageNum;}
	public function set pageNum(value:uint):void {
		if (_pageNum != value) {
			_pageNum = value;
			dispatchEvent(new Event("curPageNumChanged"));
		}
	}

	//--------------------------------------
	//  allNotesAmount
	//--------------------------------------
	private var _allNotesAmount:int = 0;
	[Bindable("allNotesAmountChanged")]
	public function get allNotesAmount():int {return _allNotesAmount;}
	public function set allNotesAmount(value:int):void {
		if (_allNotesAmount != value) {
			_allNotesAmount = value;
			dispatchEvent(new Event("allNotesAmountChanged"));
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
	}

	public function loadPage(searchText:String, loadExamples:Boolean, loadWords:Boolean, loadVerbs:Boolean, loadLessons:Boolean):void {
		var page:SearchPageInfo = new SearchPageInfo();
		page.lang = selectedLang;
		page.searchText = searchText;
		page.pageNum = pageNum;
		page.pageSize = pageSize;
		page.loadExamples = loadExamples;
		page.vocabularyIDs = [];
		if (loadWords) page.vocabularyIDs.push(VocabularyID.DE_WORD);
		if (loadVerbs) page.vocabularyIDs.push(VocabularyID.DE_VERB);
		if (loadLessons) page.vocabularyIDs.push(VocabularyID.DE_LESSON);

		var op:IAsyncOperation = sqlStorage.searchNotes(page);
		op.addCompleteCallback(onPageLoaded)
	}

	private function onPageLoaded(op:IAsyncOperation):void {
		var page:SearchPageInfo = op.result as SearchPageInfo;
		noteColl = new ArrayCollection(page.notes);
		allNotesAmount = page.allNotesAmount;
	}

	override protected function deactivate():void {}

}
}