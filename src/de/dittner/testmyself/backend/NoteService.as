package de.dittner.testmyself.backend {
import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.satelliteFlight.message.IRequestMessage;
import de.dittner.satelliteFlight.proxy.SFProxy;
import de.dittner.testmyself.backend.command.backend.ClearTestHistorySQLOperation;
import de.dittner.testmyself.backend.command.backend.CountTestTasksSQLOperation;
import de.dittner.testmyself.backend.command.backend.CreateDataBaseSQLOperation;
import de.dittner.testmyself.backend.command.backend.DeleteNoteExampleSQLOperation;
import de.dittner.testmyself.backend.command.backend.DeleteNoteSQLOperation;
import de.dittner.testmyself.backend.command.backend.DeleteNotesByThemeSQLOperation;
import de.dittner.testmyself.backend.command.backend.DeleteThemeSQLOperation;
import de.dittner.testmyself.backend.command.backend.GetDataBaseInfoSQLOperation;
import de.dittner.testmyself.backend.command.backend.InsertNoteSQLOperation;
import de.dittner.testmyself.backend.command.backend.InsertThemeSQLOperation;
import de.dittner.testmyself.backend.command.backend.MergeThemesSQLOperation;
import de.dittner.testmyself.backend.command.backend.RebuildTestTasksSQLOperation;
import de.dittner.testmyself.backend.command.backend.SearchNotesSQLOperation;
import de.dittner.testmyself.backend.command.backend.SelectExampleSQLOperation;
import de.dittner.testmyself.backend.command.backend.SelectExamplesSQLOperation;
import de.dittner.testmyself.backend.command.backend.SelectFilterSQLOperation;
import de.dittner.testmyself.backend.command.backend.SelectNoteKeysSQLOperation;
import de.dittner.testmyself.backend.command.backend.SelectNoteSQLOperation;
import de.dittner.testmyself.backend.command.backend.SelectPageNotesSQLOperation;
import de.dittner.testmyself.backend.command.backend.SelectPageTestTasksSQLOperation;
import de.dittner.testmyself.backend.command.backend.SelectTestTasksSQLOperation;
import de.dittner.testmyself.backend.command.backend.SelectThemeSQLOperation;
import de.dittner.testmyself.backend.command.backend.UpdateNoteExampleSQLOperation;
import de.dittner.testmyself.backend.command.backend.UpdateNoteSQLOperation;
import de.dittner.testmyself.backend.command.backend.UpdateTestTaskSQLOperation;
import de.dittner.testmyself.backend.command.backend.UpdateThemeSQLOperation;
import de.dittner.testmyself.backend.command.backend.deferredOperation.IDeferredCommandManager;
import de.dittner.testmyself.model.domain.note.INoteModel;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.note.NoteSuite;
import de.dittner.testmyself.model.domain.note.NotesInfo;
import de.dittner.testmyself.model.domain.note.SQLFactory;
import de.dittner.testmyself.model.domain.test.TestInfo;
import de.dittner.testmyself.model.domain.test.TestModel;
import de.dittner.testmyself.model.domain.test.TestTask;
import de.dittner.testmyself.model.domain.theme.Theme;
import de.dittner.testmyself.model.page.INotePageInfo;
import de.dittner.testmyself.model.page.NotePageInfo;
import de.dittner.testmyself.model.page.TestPageInfo;
import de.dittner.testmyself.model.search.SearchSpec;
import de.dittner.testmyself.model.settings.SettingsModel;

import flash.data.SQLConnection;

public class NoteService extends SFProxy {

	public function NoteService() {}

	[Inject]
	public var deferredCommandManager:IDeferredCommandManager;

	[Inject]
	public var settingsModel:SettingsModel;

	[Inject]
	public var model:INoteModel;

	[Inject]
	public var testModel:TestModel;

	[Inject]
	public var sqlFactory:SQLFactory;

	[Inject]
	public var spec:NoteServiceSpec;

	public var sqlConnection:SQLConnection;

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override protected function activate():void {
		reloadDataBase();
	}

	public function reloadDataBase(requestMsg:IRequestMessage = null):void {
		if (sqlConnection) {
			sqlConnection.close();
		}

		sqlConnection = new SQLConnection();

		var op:IAsyncCommand = new CreateDataBaseSQLOperation(this, spec);
		deferredCommandManager.add(op);
		if (requestMsg) requestHandler(requestMsg, op);
		updateNoteHash();

		/*var columns:Object = {};
		 columns["correct"] = true;
		 columns["incorrect"] = true;
		 op = new DropColumnSQLOperation(sqlConnection, "test", columns, sqlFactory.createTestTbl, sqlFactory.insertTestTask);
		 deferredCommandManager.add(op);
		 op = new DropColumnSQLOperation(sqlConnection, "testExample", columns, sqlFactory.createTestExampleTbl, sqlFactory.insertTestExampleTask);
		 deferredCommandManager.add(op);*/
	}

	private function updateNoteHash():void {
		var op:IAsyncCommand = new SelectNoteKeysSQLOperation(this, sqlFactory, spec.noteClass);
		op.addCompleteCallback(initializeNoteHash);
		deferredCommandManager.add(op);
	}

	public function add(requestMsg:IRequestMessage):void {
		var suite:NoteSuite = requestMsg.data as NoteSuite;
		var op:IAsyncCommand = new InsertNoteSQLOperation(this, suite, testModel);
		op.addCompleteCallback(noteAdded);
		requestHandler(requestMsg, op);
		deferredCommandManager.add(op);
	}

	public function update(requestMsg:IRequestMessage):void {
		var suite:NoteSuite = requestMsg.data as NoteSuite;
		var op:IAsyncCommand = new UpdateNoteSQLOperation(this, suite, testModel);
		op.addCompleteCallback(noteUpdated);
		requestHandler(requestMsg, op);
		deferredCommandManager.add(op);
	}

	public function remove(requestMsg:IRequestMessage):void {
		var suite:NoteSuite = requestMsg.data as NoteSuite;
		var op:IAsyncCommand = new DeleteNoteSQLOperation(this, suite);
		op.addCompleteCallback(noteRemoved);
		requestHandler(requestMsg, op);
		deferredCommandManager.add(op);
	}

	public function removeNotesByTheme(requestMsg:IRequestMessage):void {
		var op:IAsyncCommand = new DeleteNotesByThemeSQLOperation(this, (requestMsg.data as Theme).id);
		op.addCompleteCallback(notesByThemeRemoved);
		requestHandler(requestMsg, op);
		deferredCommandManager.add(op);
	}

	public function addTheme(requestMsg:IRequestMessage):void {
		var theme:Theme = requestMsg.data as Theme;
		var op:IAsyncCommand = new InsertThemeSQLOperation(this, theme);
		op.addCompleteCallback(themeAdded);
		requestHandler(requestMsg, op);
		deferredCommandManager.add(op);
	}

	public function loadNote(requestMsg:IRequestMessage):void {
		var noteID:int = requestMsg.data as int;
		var op:IAsyncCommand = new SelectNoteSQLOperation(this, noteID, spec.noteClass);
		requestHandler(requestMsg, op);
		deferredCommandManager.add(op);
	}

	public function loadNotePageInfo(requestMsg:IRequestMessage = null):void {
		var pageNum:uint;
		if (requestMsg) pageNum = requestMsg.data as uint;
		else if (model.pageInfo) pageNum = model.pageInfo.pageNum;
		else pageNum = 0;

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

	public function loadThemes(requestMsg:IRequestMessage = null):void {
		var op:IAsyncCommand = new SelectThemeSQLOperation(this);
		op.addCompleteCallback(themesLoaded);
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
		var testInfo:TestInfo = requestMsg.data as TestInfo;
		var op:IAsyncCommand = new ClearTestHistorySQLOperation(this, testInfo, testModel);
		requestHandler(requestMsg, op);
		deferredCommandManager.add(op);
	}

	public function rebuildTestTasks():void {
		var op:IAsyncCommand = new RebuildTestTasksSQLOperation(this, testModel, spec.noteClass);
		deferredCommandManager.add(op);
	}

	public function updateTheme(requestMsg:IRequestMessage):void {
		var op:IAsyncCommand = new UpdateThemeSQLOperation(this, requestMsg.data as Theme);
		op.addCompleteCallback(themesUpdated);
		requestHandler(requestMsg, op);
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

	public function removeTheme(requestMsg:IRequestMessage):void {
		var op:IAsyncCommand = new DeleteThemeSQLOperation(this, (requestMsg.data as Theme).id);
		op.addCompleteCallback(themesUpdated);
		requestHandler(requestMsg, op);
		deferredCommandManager.add(op);
	}

	public function mergeThemes(requestMsg:IRequestMessage):void {
		var destThemeID:int = (requestMsg.data.destTheme as Theme).id;
		var srcThemeID:int = (requestMsg.data.srcTheme as Theme).id;
		var op:IAsyncCommand = new MergeThemesSQLOperation(this, destThemeID, srcThemeID);
		op.addCompleteCallback(themesUpdated);
		requestHandler(requestMsg, op);
		deferredCommandManager.add(op);
	}

	public function getSelectedThemesID(requestMsg:IRequestMessage):void {
		var noteID:int = (requestMsg.data as Note).id;
		var op:IAsyncCommand = new SelectFilterSQLOperation(this, noteID);
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

	private function requestHandler(msg:IRequestMessage, op:IAsyncOperation):void {
		if (!msg) return;
		op.addCompleteCallback(function (op:IAsyncOperation):void {
			msg.onComplete(op);
		});
	}

	private function initializeNoteHash(op:IAsyncOperation):void {
		model.noteHash.init(op.result as Array);
	}

	private function noteAdded(op:IAsyncOperation):void {
		loadNotePageInfo();
		loadThemes();
		loadDBInfo();
		model.noteHash.add((op.result as NoteSuite).note);
	}

	private function themeAdded(op:IAsyncOperation):void {
		loadThemes();
	}

	private function noteUpdated(op:IAsyncOperation):void {
		loadNotePageInfo();
		loadThemes();
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
		loadThemes();
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

	private function themesUpdated(op:IAsyncOperation):void {
		loadThemes();
		model.filter.selectedThemes = [];
	}

	private function dbInfoLoaded(op:IAsyncOperation):void {
		model.dataBaseInfo = op.result as NotesInfo;
	}

}
}