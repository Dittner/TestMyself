package de.dittner.testmyself.backend {
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.cmd.RemoveNoteCmd;
import de.dittner.testmyself.backend.cmd.RemoveNotesByThemeCmd;
import de.dittner.testmyself.backend.cmd.RunDataBaseCmd;
import de.dittner.testmyself.backend.cmd.StoreNoteCmd;
import de.dittner.testmyself.backend.cmd.StoreThemeCmd;
import de.dittner.testmyself.backend.deferredOperation.IDeferredCommandManager;
import de.dittner.testmyself.backend.operation.ClearTestHistorySQLOperation;
import de.dittner.testmyself.backend.operation.CountTestTasksSQLOperation;
import de.dittner.testmyself.backend.operation.DeleteNoteExampleSQLOperation;
import de.dittner.testmyself.backend.operation.GetDataBaseInfoSQLOperation;
import de.dittner.testmyself.backend.operation.LoadAllThemesCmd;
import de.dittner.testmyself.backend.operation.MergeThemesSQLOperation;
import de.dittner.testmyself.backend.operation.RebuildTestTasksSQLOperation;
import de.dittner.testmyself.backend.operation.RemoveThemeCmd;
import de.dittner.testmyself.backend.operation.SearchNotesSQLOperation;
import de.dittner.testmyself.backend.operation.SelectExampleSQLOperation;
import de.dittner.testmyself.backend.operation.SelectExamplesSQLOperation;
import de.dittner.testmyself.backend.operation.SelectFilterSQLOperation;
import de.dittner.testmyself.backend.operation.SelectNoteSQLOperation;
import de.dittner.testmyself.backend.operation.SelectPageNotesSQLOperation;
import de.dittner.testmyself.backend.operation.SelectPageTestTasksSQLOperation;
import de.dittner.testmyself.backend.operation.SelectTestTasksSQLOperation;
import de.dittner.testmyself.backend.operation.UpdateNoteExampleSQLOperation;
import de.dittner.testmyself.backend.operation.UpdateTestTaskSQLOperation;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.note.NoteSuite;
import de.dittner.testmyself.model.domain.note.NotesInfo;
import de.dittner.testmyself.model.domain.note.SQLLib;
import de.dittner.testmyself.model.domain.test.Test;
import de.dittner.testmyself.model.domain.test.TestTask;
import de.dittner.testmyself.model.domain.theme.Theme;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;
import de.dittner.testmyself.model.page.INotePageInfo;
import de.dittner.testmyself.model.page.NotePageInfo;
import de.dittner.testmyself.model.page.TestPageInfo;
import de.dittner.testmyself.model.search.SearchSpec;
import de.dittner.testmyself.model.settings.SettingsModel;
import de.dittner.walter.WalterProxy;

import flash.data.SQLConnection;

public class SQLStorage extends WalterProxy {

	public function SQLStorage() {
		super();
	}

	[Inject]
	public var deferredCommandManager:IDeferredCommandManager;

	[Inject]
	public var settingsModel:SettingsModel;

	private var _sqlConnection:SQLConnection;
	public function get sqlConnection():SQLConnection {return _sqlConnection;}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override protected function activate():void {
		reloadDataBase();
		//updateNoteHash();
	}

	private function reloadDataBase():void {
		if (sqlConnection) {
			sqlConnection.close();
		}

		_sqlConnection = new SQLConnection();

		var cmd:IAsyncCommand = new RunDataBaseCmd("TestMyself", SQLLib.TABLES);
		cmd.addCompleteCallback(dataBaseReadyHandler);
		deferredCommandManager.add(cmd);
	}

	private function dataBaseReadyHandler(opEvent:*):void {
		_sqlConnection = opEvent.result as SQLConnection;
	}

	/*private function updateNoteHash():void {
	 var op:IAsyncCommand = new SelectNoteKeysSQLOperation(this);
	 op.addCompleteCallback(initializeNoteHash);
	 deferredCommandManager.add(op);
	 }*/

	//--------------------------------------
	//  Notes
	//--------------------------------------

	public function storeNote(note:Note):IAsyncOperation {
		var op:IAsyncCommand = new StoreNoteCmd(this, note);
		op.addCompleteCallback(noteAdded);
		deferredCommandManager.add(op);
		return op;
	}

	public function removeNote(note:Note):void {
		var op:IAsyncCommand = new RemoveNoteCmd(this, note.id);
		op.addCompleteCallback(noteRemoved);
		deferredCommandManager.add(op);
	}

	public function removeNotesByTheme(theme:Theme):void {
		var op:IAsyncCommand = new RemoveNotesByThemeCmd(this, theme);
		op.addCompleteCallback(notesByThemeRemoved);
		deferredCommandManager.add(op);
	}

	//--------------------------------------
	//  Themes
	//--------------------------------------

	public function storeTheme(theme:Theme):void {
		var op:IAsyncCommand = new StoreThemeCmd(this, theme);
		op.addCompleteCallback(themeAdded);
		deferredCommandManager.add(op);
	}

	public function loadAllThemes(vocabulary:Vocabulary):void {
		var op:IAsyncCommand = new LoadAllThemesCmd(this, vocabulary);
		op.addCompleteCallback(themesLoaded);
		deferredCommandManager.add(op);
	}

	public function removeTheme(theme:Theme):void {
		var op:IAsyncCommand = new RemoveThemeCmd(this, theme.id);
		op.addCompleteCallback(themesUpdated);
		deferredCommandManager.add(op);
	}

	public function mergeThemes(destTheme:Theme, srcTheme:Theme):void {
		var op:IAsyncCommand = new MergeThemesSQLOperation(this, destTheme.id, srcTheme.id);
		op.addCompleteCallback(themesUpdated);
		deferredCommandManager.add(op);
	}

	public function getSelectedThemesID(requestMsg:IRequestMessage):void {
		var noteID:int = (requestMsg.data as Note).id;
		var op:IAsyncCommand = new SelectFilterSQLOperation(this, noteID);
		requestHandler(requestMsg, op);
		deferredCommandManager.add(op);
	}

	//--------------------------------------
	//  MethodName
	//--------------------------------------

	public function loadNote(requestMsg:IRequestMessage):void {
		var noteID:int = requestMsg.data as int;
		var op:IAsyncCommand = new SelectNoteSQLOperation(this, noteID, spec.noteClass);
		requestHandler(requestMsg, op);
		deferredCommandManager.add(op);
	}

	public function loadNotePageInfo(vocabulary:Vocabulary, pageInfo:NotePageInfo):void {
		var pageInfo:NotePageInfo = new NotePageInfo();
		pageInfo.pageSize = settingsModel.info.pageSize;
		pageInfo.pageNum = pageNum;
		pageInfo.filter = model.filter;

		var op:IAsyncCommand = new SelectPageNotesSQLOperation(this, pageInfo, spec.noteClass);
		op.addCompleteCallback(notePageInfoLoaded);
		requestHandler(requestMsg, op);
		deferredCommandManager.add(op);
	}

	public function loadTestPageInfo(requestMsg:IRequestMessage):void {
		var pageInfo:TestPageInfo = requestMsg.data as TestPageInfo;
		pageInfo.pageSize = settingsModel.info.pageSize;
		pageInfo.testSpec = testModel.testSpec;

		var op:IAsyncCommand = new SelectPageTestTasksSQLOperation(this, pageInfo, spec.noteClass);
		requestHandler(requestMsg, op);
		deferredCommandManager.add(op);
	}

	public function searchNotes(requestMsg:IRequestMessage):void {
		var searchSpec:SearchSpec = requestMsg.data as SearchSpec;
		var op:IAsyncCommand = new SearchNotesSQLOperation(this, searchSpec);
		requestHandler(requestMsg, op);
		deferredCommandManager.add(op);
	}

	public function countTestTasks(requestMsg:IRequestMessage = null):void {
		var onlyFailedNotes:Boolean = requestMsg && requestMsg.data;
		var op:IAsyncCommand = new CountTestTasksSQLOperation(this, testModel.testSpec, onlyFailedNotes);
		requestHandler(requestMsg, op);
		deferredCommandManager.add(op);
	}

	public function loadExamples(requestMsg:IRequestMessage):void {
		var noteID:int = requestMsg.data as int;
		var op:IAsyncCommand = new SelectExamplesSQLOperation(this, noteID);
		requestHandler(requestMsg, op);
		deferredCommandManager.add(op);
	}

	public function loadExample(requestMsg:IRequestMessage):void {
		var exampleID:int = requestMsg.data as int;
		var op:IAsyncCommand = new SelectExampleSQLOperation(this, exampleID);
		requestHandler(requestMsg, op);
		deferredCommandManager.add(op);
	}

	public function loadTestTasks(requestMsg:IRequestMessage):void {
		var op:IAsyncCommand = new SelectTestTasksSQLOperation(this, testModel.testSpec);
		requestHandler(requestMsg, op);
		deferredCommandManager.add(op);
	}

	public function clearTestHistory(requestMsg:IRequestMessage):void {
		var testInfo:Test = requestMsg.data as Test;
		var op:IAsyncCommand = new ClearTestHistorySQLOperation(this, testInfo, testModel);
		requestHandler(requestMsg, op);
		deferredCommandManager.add(op);
	}

	public function rebuildTestTasks():void {
		var op:IAsyncCommand = new RebuildTestTasksSQLOperation(this, testModel, spec.noteClass);
		deferredCommandManager.add(op);
	}

	public function updateExample(requestMsg:IRequestMessage):void {
		var op:IAsyncCommand = new UpdateNoteExampleSQLOperation(this, requestMsg.data as NoteSuite);
		requestHandler(requestMsg, op);
		deferredCommandManager.add(op);
	}

	public function removeExample(requestMsg:IRequestMessage):void {
		var op:IAsyncCommand = new DeleteNoteExampleSQLOperation(this, requestMsg.data as NoteSuite);
		requestHandler(requestMsg, op);
		deferredCommandManager.add(op);
	}

	public function updateTestTask(requestMsg:IRequestMessage):void {
		var op:IAsyncCommand = new UpdateTestTaskSQLOperation(this, requestMsg.data as TestTask, testModel);
		requestHandler(requestMsg, op);
		deferredCommandManager.add(op);
	}


	public function loadDBInfo(requestMsg:IRequestMessage = null):void {
		var op:IAsyncCommand = new GetDataBaseInfoSQLOperation(this, model.filter);
		op.addCompleteCallback(dbInfoLoaded);
		requestHandler(requestMsg, op);
		deferredCommandManager.add(op);
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Handlers
	//
	//----------------------------------------------------------------------------------------------

	private function initializeNoteHash(op:IAsyncOperation):void {
		model.noteHash.init(op.result as Array);
	}

	private function noteAdded(op:IAsyncOperation):void {
		loadNotePageInfo();
		loadAllThemes();
		loadDBInfo();
		model.noteHash.add((op.result as NoteSuite).note);
	}

	private function noteUpdated(op:IAsyncOperation):void {
		loadNotePageInfo();
		loadAllThemes();
		loadDBInfo();
		model.noteHash.update((op.result as NoteSuite).note, (op.result as NoteSuite).origin);
	}

	private function noteRemoved(op:IAsyncOperation):void {
		loadNotePageInfo();
		loadDBInfo();
		model.noteHash.remove((op.result as NoteSuite).note);
	}

	private function notesByThemeRemoved(op:IAsyncOperation):void {
		loadNotePageInfo();
		loadAllThemes();
		loadDBInfo();
		updateNoteHash();
	}

	private function notePageInfoLoaded(op:IAsyncOperation):void {
		model.selectedNote = (op.result as INotePageInfo).selectedNote;
		model.pageInfo = op.result as NotePageInfo;
	}

	private function themesLoaded(op:IAsyncOperation):void {
		model.themes = op.result as Array;
	}

	private function themeAdded(op:IAsyncOperation):void {
		loadAllThemes();
	}
	private function themesUpdated(op:IAsyncOperation):void {
		loadAllThemes();
		model.filter.selectedThemes = [];
	}

	private function dbInfoLoaded(op:IAsyncOperation):void {
		model.dataBaseInfo = op.result as NotesInfo;
	}

}
}