package de.dittner.testmyself.ui.view.noteList {
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.model.AppModel;
import de.dittner.testmyself.model.domain.language.Language;
import de.dittner.testmyself.model.domain.note.INote;
import de.dittner.testmyself.model.domain.vocabulary.VocabularyID;
import de.dittner.testmyself.ui.common.page.NotePageInfo;
import de.dittner.testmyself.ui.common.view.ViewID;
import de.dittner.testmyself.ui.common.view.ViewInfo;
import de.dittner.testmyself.ui.common.view.ViewModel;

import flash.events.Event;

public class NoteListVM extends ViewModel {

	public function NoteListVM() {
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
	private var _page:NotePageInfo;
	[Bindable("pageChanged")]
	public function get page():NotePageInfo {return _page;}
	public function set page(value:NotePageInfo):void {
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

		page = new NotePageInfo();
		page.vocabulary = appModel.selectedLanguage.vocabularyHash.read(vocabularyID);
		reloadPage();
	}

	public function reloadPage():void {
		selectedNote = null;
		selectedExample = null;
		storage.loadNotePage(page);
	}
}
}