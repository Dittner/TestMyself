package de.dittner.testmyself.ui.view.wordList {
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.backend.message.NoteMsg;
import de.dittner.testmyself.model.AppModel;
import de.dittner.testmyself.model.domain.language.Language;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;
import de.dittner.testmyself.model.domain.vocabulary.VocabularyID;
import de.dittner.testmyself.model.page.NotePageRequest;
import de.dittner.testmyself.ui.view.vocabulary.note.filter.NoteFilterMediator;
import de.dittner.testmyself.ui.view.vocabulary.note.form.NoteRemoverMediator;
import de.dittner.testmyself.ui.view.vocabulary.note.list.ExampleListMediator;
import de.dittner.testmyself.ui.view.vocabulary.note.list.NoteListMediator;
import de.dittner.testmyself.ui.view.vocabulary.note.mp3Player.NotePlayerMediator;
import de.dittner.testmyself.ui.view.vocabulary.note.pagination.NotePaginationMediator;
import de.dittner.testmyself.ui.view.vocabulary.note.search.NoteSearchMediator;
import de.dittner.testmyself.ui.view.vocabulary.note.toolbar.NoteToolbarMediator;
import de.dittner.testmyself.ui.view.vocabulary.word.form.WordCreatorMediator;
import de.dittner.testmyself.ui.view.vocabulary.word.form.WordEditorMediator;
import de.dittner.walter.WalterProxy;

import mx.collections.ArrayCollection;

public class WordListVM extends WalterProxy {

	private static const PAGE_SIZE:uint = 10;

	public function WordListVM() {
		super();
	}

	[Inject]
	public var sqlStorage:SQLStorage;

	[Inject]
	public var appModel:AppModel;

	[Bindable]
	public var selectedLang:Language;
	[Bindable]
	public var selectedVocabulary:Vocabulary;
	[Bindable]
	public var availableNoteColl:ArrayCollection;

	private var curPageNum:uint = 0;

	override protected function activate():void {}

	public function viewActivated():void {
		selectedLang = appModel.selectedLanguage;
		selectedVocabulary = appModel.selectedLanguage.vocabularyHash.read(VocabularyID.DE_WORD);
		loadPage(curPageNum);
	}

	private function loadPage(pageNum:uint = 0):void {
		var pageRequest:NotePageRequest = new NotePageRequest();
		pageRequest.pageNum = pageNum;
		pageRequest.pageSize = PAGE_SIZE;
		pageRequest.vocabulary = selectedVocabulary;
		var op:IAsyncOperation = sqlStorage.loadNotePage(pageRequest);
		op.addCompleteCallback(onPageInfoLoaded)
	}

	public function loadNextPage():void {
		loadPage(++curPageNum);
	}

	public function loadPrevPage():void {
		if (curPageNum >= 0) loadPage(--curPageNum);
	}

	private function onPageInfoLoaded(op:IAsyncOperation):void {
		availableNoteColl = new ArrayCollection(op.isSuccess ? (op.result as NotePageRequest).notes : []);
	}

	private function activateScreen():void {
		addListener(NoteMsg.FORM_ACTIVATED_NOTIFICATION, showEditor);
		addListener(NoteMsg.FORM_DEACTIVATED_NOTIFICATION, hideEditor);
		registerMediator(view.toolbar, new NoteToolbarMediator());
		registerMediator(view.form, new WordCreatorMediator());
		registerMediator(view.form, new WordEditorMediator());
		registerMediator(view.form, new NoteRemoverMediator());
		registerMediator(view.list, new NoteListMediator());
		registerMediator(view.filter, new NoteFilterMediator());
		registerMediator(view.searchFilter, new NoteSearchMediator());
		registerMediator(view.paginationBar, new NotePaginationMediator());
		registerMediator(view.mp3Player, new NotePlayerMediator());
		registerMediator(view.exampleList, new ExampleListMediator());
	}

	private function showEditor(params:* = null):void {
		view.showEditor();
	}

	private function hideEditor(params:* = null):void {
		view.hideEditor();
	}

	override protected function deactivate():void {
		view.deactivate();
	}

}
}