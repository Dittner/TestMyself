package de.dittner.testmyself.ui.view.noteList {
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.model.AppModel;
import de.dittner.testmyself.model.domain.language.Language;
import de.dittner.testmyself.model.domain.theme.Theme;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;
import de.dittner.testmyself.model.domain.vocabulary.VocabularyID;
import de.dittner.testmyself.model.page.NotePageInfo;
import de.dittner.testmyself.ui.common.view.ViewID;
import de.dittner.testmyself.ui.common.view.ViewInfo;
import de.dittner.testmyself.ui.common.view.ViewModel;

import flash.events.Event;

import mx.collections.ArrayCollection;

public class NoteListVM extends ViewModel {

	public function NoteListVM() {
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
	[Bindable]
	public var selectedVocabulary:Vocabulary;

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
	//  selectedTheme
	//--------------------------------------
	private var _selectedTheme:Theme;
	[Bindable("selectedThemeChanged")]
	public function get selectedTheme():Theme {return _selectedTheme;}
	public function set selectedTheme(value:Theme):void {
		if (_selectedTheme != value) {
			_selectedTheme = value;
			if (isActive) {
				curPageNum = 0;
				loadPage();
			}
			dispatchEvent(new Event("selectedThemeChanged"));
		}
	}

	//--------------------------------------
	//  pageSize
	//--------------------------------------
	public function get pageSize():uint {return 10;}

	//--------------------------------------
	//  curPageNum
	//--------------------------------------
	private var _curPageNum:uint = 0;
	[Bindable("curPageNumChanged")]
	public function get curPageNum():uint {return _curPageNum;}
	public function set curPageNum(value:uint):void {
		if (_curPageNum != value) {
			_curPageNum = value;
			if (isActive) loadPage();
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

	override protected function activate():void {}

	override public function viewActivated(info:ViewInfo):void {
		super.viewActivated(info);
		selectedLang = appModel.selectedLanguage;
		var vocabularyID:uint;
		switch (info.id) {
			case ViewID.WORD :
				vocabularyID = VocabularyID.DE_WORD;
				break;
			case ViewID.VERB :
				vocabularyID = VocabularyID.DE_VERB;
				break;
			case ViewID.LESSON :
				vocabularyID = VocabularyID.DE_LESSON;
				break;
			default :
				throw new Error("Unsupported VM for view with ID = " + info.id);
				break;
		}

		selectedVocabulary = appModel.selectedLanguage.vocabularyHash.read(vocabularyID);
		loadPage();
	}

	private function loadPage():void {
		var page:NotePageInfo = new NotePageInfo();
		page.pageNum = curPageNum;
		page.pageSize = pageSize;
		page.vocabulary = selectedVocabulary;
		var op:IAsyncOperation = sqlStorage.loadNotePage(page);
		op.addCompleteCallback(onPageInfoLoaded)
	}

	private function onPageInfoLoaded(op:IAsyncOperation):void {
		var page:NotePageInfo = op.result as NotePageInfo;
		noteColl = new ArrayCollection(page.notes);
		allNotesAmount = page.allNotesAmount;
	}

	override protected function deactivate():void {}

}
}