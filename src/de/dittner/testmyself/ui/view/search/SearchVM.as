package de.dittner.testmyself.ui.view.search {
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.model.domain.audioComment.AudioComment;
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