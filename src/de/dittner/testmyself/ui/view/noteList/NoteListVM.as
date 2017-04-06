package de.dittner.testmyself.ui.view.noteList {
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.model.domain.language.Language;
import de.dittner.testmyself.model.domain.language.LanguageID;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.vocabulary.VocabularyID;
import de.dittner.testmyself.ui.common.menu.ViewID;
import de.dittner.testmyself.ui.common.page.NotePage;
import de.dittner.testmyself.ui.common.view.ViewModel;

import flash.events.Event;

import mx.resources.ResourceManager;

public class NoteListVM extends ViewModel {

	public function NoteListVM() {
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
	private var _page:NotePage;
	[Bindable("pageChanged")]
	public function get page():NotePage {return _page;}
	private function setPage(value:NotePage):void {
		if (_page != value) {
			_page = value;
			dispatchEvent(new Event("pageChanged"));
		}
	}

	//--------------------------------------
	//  selectedNote
	//--------------------------------------
	private var _selectedNote:Note;
	[Bindable("selectedNoteChanged")]
	public function get selectedNote():Note {return _selectedNote;}
	public function set selectedNote(value:Note):void {
		if (_selectedNote != value) {
			_selectedNote = value;
			dispatchEvent(new Event("selectedNoteChanged"));
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override public function viewActivated(viewID:String):void {
		super.viewActivated(viewID);
		selectedLang = appModel.selectedLanguage;
		var vocabularyID:uint;
		switch (viewID) {
			case ViewID.WORD :
				vocabularyID = appModel.selectedLanguage.id == LanguageID.DE ? VocabularyID.DE_WORD : VocabularyID.EN_WORD;
				viewTitle = ResourceManager.getInstance().getString('app', 'DICTIONARY');
				break;
			case ViewID.VERB :
				vocabularyID = appModel.selectedLanguage.id == LanguageID.DE ? VocabularyID.DE_VERB : VocabularyID.EN_VERB;
				viewTitle = ResourceManager.getInstance().getString('app', 'IRREGULAR_VERBS');
				break;
			case ViewID.LESSON :
				vocabularyID = appModel.selectedLanguage.id == LanguageID.DE ? VocabularyID.DE_LESSON : VocabularyID.EN_LESSON;
				viewTitle = ResourceManager.getInstance().getString('app', 'LESSONS');
				break;
			default :
				throw new Error("Unsupported VM for view with ID = " + viewID);
				break;
		}

		var p:NotePage = new NotePage();
		p.vocabulary = appModel.selectedLanguage.vocabularyHash.read(vocabularyID);
		setPage(p);
	}

	public function reloadPage():void {
		selectedNote = null;
		if(page) storage.loadNotePage(page);
	}
}
}