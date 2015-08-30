package dittner.testmyself.core.service {
import dittner.satelliteFlight.message.IRequestMessage;
import dittner.satelliteFlight.proxy.SFProxy;
import dittner.testmyself.core.async.IAsyncOperation;
import dittner.testmyself.core.async.ICommand;
import dittner.testmyself.core.command.backend.ClearTestHistorySQLOperation;
import dittner.testmyself.core.command.backend.CountTestTasksSQLOperation;
import dittner.testmyself.core.command.backend.CreateDataBaseSQLOperation;
import dittner.testmyself.core.command.backend.DeleteNoteExampleSQLOperation;
import dittner.testmyself.core.command.backend.DeleteNoteSQLOperation;
import dittner.testmyself.core.command.backend.DeleteNotesByThemeSQLOperation;
import dittner.testmyself.core.command.backend.DeleteThemeSQLOperation;
import dittner.testmyself.core.command.backend.GetDataBaseInfoSQLOperation;
import dittner.testmyself.core.command.backend.InsertNoteSQLOperation;
import dittner.testmyself.core.command.backend.InsertThemeSQLOperation;
import dittner.testmyself.core.command.backend.MergeThemesSQLOperation;
import dittner.testmyself.core.command.backend.RebuildTestTasksSQLOperation;
import dittner.testmyself.core.command.backend.SearchNotesSQLOperation;
import dittner.testmyself.core.command.backend.SelectExampleSQLOperation;
import dittner.testmyself.core.command.backend.SelectExamplesSQLOperation;
import dittner.testmyself.core.command.backend.SelectFilterSQLOperation;
import dittner.testmyself.core.command.backend.SelectNoteKeysSQLOperation;
import dittner.testmyself.core.command.backend.SelectNoteSQLOperation;
import dittner.testmyself.core.command.backend.SelectPageNotesSQLOperation;
import dittner.testmyself.core.command.backend.SelectPageTestTasksSQLOperation;
import dittner.testmyself.core.command.backend.SelectTestTasksSQLOperation;
import dittner.testmyself.core.command.backend.SelectThemeSQLOperation;
import dittner.testmyself.core.command.backend.UpdateNoteExampleSQLOperation;
import dittner.testmyself.core.command.backend.UpdateNoteSQLOperation;
import dittner.testmyself.core.command.backend.UpdateTestTaskSQLOperation;
import dittner.testmyself.core.command.backend.UpdateThemeSQLOperation;
import dittner.testmyself.core.command.backend.deferredOperation.IDeferredCommandManager;
import dittner.testmyself.core.model.note.INoteModel;
import dittner.testmyself.core.model.note.Note;
import dittner.testmyself.core.model.note.NoteSuite;
import dittner.testmyself.core.model.note.NotesInfo;
import dittner.testmyself.core.model.note.SQLFactory;
import dittner.testmyself.core.model.page.INotePageInfo;
import dittner.testmyself.core.model.page.NotePageInfo;
import dittner.testmyself.core.model.page.TestPageInfo;
import dittner.testmyself.core.model.test.TestInfo;
import dittner.testmyself.core.model.test.TestModel;
import dittner.testmyself.core.model.test.TestTask;
import dittner.testmyself.core.model.theme.Theme;
import dittner.testmyself.deutsch.model.search.SearchSpec;
import dittner.testmyself.deutsch.model.settings.SettingsModel;

import flash.data.SQLConnection;

public class NoteService extends SFProxy {

	public function NoteService() {
		sqlConnection = new SQLConnection();
	}

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
		var op:ICommand = new CreateDataBaseSQLOperation(this, spec);
		deferredCommandManager.add(op);
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
		var op:ICommand = new SelectNoteKeysSQLOperation(this, sqlFactory, spec.noteClass);
		op.addCompleteCallback(initializeNoteHash);
		deferredCommandManager.add(op);
	}

	public function add(requestMsg:IRequestMessage):void {
		var suite:NoteSuite = requestMsg.data as NoteSuite;
		var op:ICommand = new InsertNoteSQLOperation(this, suite, testModel);
		op.addCompleteCallback(noteAdded);
		requestHandler(requestMsg, op);
		deferredCommandManager.add(op);
	}

	public function update(requestMsg:IRequestMessage):void {
		var suite:NoteSuite = requestMsg.data as NoteSuite;
		var op:ICommand = new UpdateNoteSQLOperation(this, suite, testModel);
		op.addCompleteCallback(noteUpdated);
		requestHandler(requestMsg, op);
		deferredCommandManager.add(op);
	}

	public function remove(requestMsg:IRequestMessage):void {
		var suite:NoteSuite = requestMsg.data as NoteSuite;
		var op:ICommand = new DeleteNoteSQLOperation(this, suite);
		op.addCompleteCallback(noteRemoved);
		requestHandler(requestMsg, op);
		deferredCommandManager.add(op);
	}

	public function removeNotesByTheme(requestMsg:IRequestMessage):void {
		var op:ICommand = new DeleteNotesByThemeSQLOperation(this, (requestMsg.data as Theme).id);
		op.addCompleteCallback(notesByThemeRemoved);
		requestHandler(requestMsg, op);
		deferredCommandManager.add(op);
	}

	public function addTheme(requestMsg:IRequestMessage):void {
		var theme:Theme = requestMsg.data as Theme;
		var op:ICommand = new InsertThemeSQLOperation(this, theme);
		op.addCompleteCallback(themeAdded);
		requestHandler(requestMsg, op);
		deferredCommandManager.add(op);
	}

	public function loadNote(requestMsg:IRequestMessage):void {
		var noteID:int = requestMsg.data as int;
		var op:ICommand = new SelectNoteSQLOperation(this, noteID, spec.noteClass);
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

		var op:ICommand = new SelectPageNotesSQLOperation(this, pageInfo, spec.noteClass);
		op.addCompleteCallback(notePageInfoLoaded);
		requestHandler(requestMsg, op);
		deferredCommandManager.add(op);
	}

	public function loadTestPageInfo(requestMsg:IRequestMessage):void {
		var pageInfo:TestPageInfo = requestMsg.data as TestPageInfo;
		pageInfo.pageSize = settingsModel.info.pageSize;
		pageInfo.testSpec = testModel.testSpec;

		var op:ICommand = new SelectPageTestTasksSQLOperation(this, pageInfo, spec.noteClass);
		requestHandler(requestMsg, op);
		deferredCommandManager.add(op);
	}

	public function searchNotes(requestMsg:IRequestMessage):void {
		var searchSpec:SearchSpec = requestMsg.data as SearchSpec;
		var op:ICommand = new SearchNotesSQLOperation(this, searchSpec);
		requestHandler(requestMsg, op);
		deferredCommandManager.add(op);
	}

	public function countTestTasks(requestMsg:IRequestMessage = null):void {
		var onlyFailedNotes:Boolean = requestMsg && requestMsg.data;
		var op:ICommand = new CountTestTasksSQLOperation(this, testModel.testSpec, onlyFailedNotes);
		requestHandler(requestMsg, op);
		deferredCommandManager.add(op);
	}

	public function loadThemes(requestMsg:IRequestMessage = null):void {
		var op:ICommand = new SelectThemeSQLOperation(this);
		op.addCompleteCallback(themesLoaded);
		requestHandler(requestMsg, op);
		deferredCommandManager.add(op);
	}

	public function loadExamples(requestMsg:IRequestMessage):void {
		var noteID:int = requestMsg.data as int;
		var op:ICommand = new SelectExamplesSQLOperation(this, noteID);
		requestHandler(requestMsg, op);
		deferredCommandManager.add(op);
	}

	public function loadExample(requestMsg:IRequestMessage):void {
		var exampleID:int = requestMsg.data as int;
		var op:ICommand = new SelectExampleSQLOperation(this, exampleID);
		requestHandler(requestMsg, op);
		deferredCommandManager.add(op);
	}

	public function loadTestTasks(requestMsg:IRequestMessage):void {
		var op:ICommand = new SelectTestTasksSQLOperation(this, testModel.testSpec);
		requestHandler(requestMsg, op);
		deferredCommandManager.add(op);
	}

	public function clearTestHistory(requestMsg:IRequestMessage):void {
		var testInfo:TestInfo = requestMsg.data as TestInfo;
		var op:ICommand = new ClearTestHistorySQLOperation(this, testInfo, testModel);
		requestHandler(requestMsg, op);
		deferredCommandManager.add(op);
	}

	public function rebuildTestTasks():void {
		var op:ICommand = new RebuildTestTasksSQLOperation(this, testModel, spec.noteClass);
		deferredCommandManager.add(op);
	}

	public function updateTheme(requestMsg:IRequestMessage):void {
		var op:ICommand = new UpdateThemeSQLOperation(this, requestMsg.data as Theme);
		op.addCompleteCallback(themesUpdated);
		requestHandler(requestMsg, op);
		deferredCommandManager.add(op);
	}

	public function updateExample(requestMsg:IRequestMessage):void {
		var op:ICommand = new UpdateNoteExampleSQLOperation(this, requestMsg.data as NoteSuite);
		requestHandler(requestMsg, op);
		deferredCommandManager.add(op);
	}

	public function removeExample(requestMsg:IRequestMessage):void {
		var op:ICommand = new DeleteNoteExampleSQLOperation(this, requestMsg.data as NoteSuite);
		requestHandler(requestMsg, op);
		deferredCommandManager.add(op);
	}

	public function updateTestTask(requestMsg:IRequestMessage):void {
		var op:ICommand = new UpdateTestTaskSQLOperation(this, requestMsg.data as TestTask, testModel);
		requestHandler(requestMsg, op);
		deferredCommandManager.add(op);
	}

	public function removeTheme(requestMsg:IRequestMessage):void {
		var op:ICommand = new DeleteThemeSQLOperation(this, (requestMsg.data as Theme).id);
		op.addCompleteCallback(themesUpdated);
		requestHandler(requestMsg, op);
		deferredCommandManager.add(op);
	}

	public function mergeThemes(requestMsg:IRequestMessage):void {
		var destThemeID:int = (requestMsg.data.destTheme as Theme).id;
		var srcThemeID:int = (requestMsg.data.srcTheme as Theme).id;
		var op:ICommand = new MergeThemesSQLOperation(this, destThemeID, srcThemeID);
		op.addCompleteCallback(themesUpdated);
		requestHandler(requestMsg, op);
		deferredCommandManager.add(op);
	}

	public function getSelectedThemesID(requestMsg:IRequestMessage):void {
		var noteID:int = (requestMsg.data as Note).id;
		var op:ICommand = new SelectFilterSQLOperation(this, noteID);
		requestHandler(requestMsg, op);
		deferredCommandManager.add(op);
	}

	public function loadDBInfo(requestMsg:IRequestMessage = null):void {
		var op:ICommand = new GetDataBaseInfoSQLOperation(this, model.filter);
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