package de.dittner.testmyself.ui.view.noteList {
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.model.domain.audioComment.AudioComment;
import de.dittner.testmyself.model.domain.language.Language;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.vocabulary.VocabularyID;
import de.dittner.testmyself.ui.common.menu.MenuID;
import de.dittner.testmyself.ui.common.page.NotePage;
import de.dittner.testmyself.ui.common.view.ViewModel;

import flash.events.Event;

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
			if (_selectedNote && _selectedNote.hasAudio && _selectedNote.audioComment.isEmpty)
				_selectedNote.loadAudioComment().addCompleteCallback(updateAudioComment);
			updateAudioComment();
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
			if (_selectedExample && _selectedExample.hasAudio && _selectedExample.audioComment.isEmpty)
				_selectedExample.loadAudioComment().addCompleteCallback(updateAudioComment);
			updateAudioComment();
			dispatchEvent(new Event("selectedExampleChanged"));
		}
	}

	//--------------------------------------
	//  audioComment
	//--------------------------------------
	private var _audioComment:AudioComment;
	[Bindable("audioCommentChanged")]
	public function get audioComment():AudioComment {return _audioComment;}
	private function updateAudioComment(op:IAsyncOperation = null):void {
		if (selectedExample && !selectedExample.audioComment.isEmpty) _audioComment = selectedExample.audioComment;
		else _audioComment = selectedNote ? selectedNote.audioComment : null;
		dispatchEvent(new Event("audioCommentChanged"))
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
			case MenuID.WORD :
				vocabularyID = VocabularyID.DE_WORD;
				viewTitle = "WÖRTERBUCH";
				break;
			case MenuID.VERB :
				vocabularyID = VocabularyID.DE_VERB;
				viewTitle = "STARKE VERBEN";
				break;
			case MenuID.LESSON :
				vocabularyID = VocabularyID.DE_LESSON;
				viewTitle = "ÜBUNGEN";
				break;
			default :
				throw new Error("Unsupported VM for view with ID = " + viewID);
				break;
		}

		var p:NotePage = new NotePage();
		p.vocabulary = appModel.selectedLanguage.vocabularyHash.read(vocabularyID);
		setPage(p);
		reloadPage();
	}

	public function reloadPage():void {
		selectedNote = null;
		selectedExample = null;
		storage.loadNotePage(page);
	}
}
}