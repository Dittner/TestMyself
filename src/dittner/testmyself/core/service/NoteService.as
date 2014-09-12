package dittner.testmyself.core.service {
import com.probertson.data.SQLRunner;

import dittner.satelliteFlight.command.CommandException;
import dittner.satelliteFlight.command.CommandResult;
import dittner.satelliteFlight.message.IRequestMessage;
import dittner.satelliteFlight.proxy.SFProxy;
import dittner.testmyself.core.command.backend.CreateDataBaseSQLOperation;
import dittner.testmyself.core.command.backend.DeleteNoteSQLOperation;
import dittner.testmyself.core.command.backend.DeleteThemeSQLOperation;
import dittner.testmyself.core.command.backend.GetDataBaseInfoSQLOperation;
import dittner.testmyself.core.command.backend.InsertNoteSQLOperation;
import dittner.testmyself.core.command.backend.MergeThemesSQLOperation;
import dittner.testmyself.core.command.backend.SelectExamplesSQLOperation;
import dittner.testmyself.core.command.backend.SelectFilterSQLOperation;
import dittner.testmyself.core.command.backend.SelectNoteKeysSQLOperation;
import dittner.testmyself.core.command.backend.SelectNoteSQLOperation;
import dittner.testmyself.core.command.backend.SelectThemeSQLOperation;
import dittner.testmyself.core.command.backend.UpdateNoteSQLOperation;
import dittner.testmyself.core.command.backend.UpdateThemeSQLOperation;
import dittner.testmyself.core.command.backend.deferredOperation.IDeferredOperation;
import dittner.testmyself.core.command.backend.deferredOperation.IDeferredOperationManager;
import dittner.testmyself.core.model.note.INoteModel;
import dittner.testmyself.core.model.note.Note;
import dittner.testmyself.core.model.note.NoteSuite;
import dittner.testmyself.core.model.note.NotesInfo;
import dittner.testmyself.core.model.note.SQLFactory;
import dittner.testmyself.core.model.page.IPageInfo;
import dittner.testmyself.core.model.page.PageInfo;
import dittner.testmyself.core.model.theme.Theme;
import dittner.testmyself.deutsch.model.settings.SettingsModel;

public class NoteService extends SFProxy {

	public function NoteService() {}

	[Inject]
	public var deferredOperationManager:IDeferredOperationManager;

	[Inject]
	public var settingsModel:SettingsModel;

	[Inject]
	public var model:INoteModel;

	[Inject]
	public var sqlFactory:SQLFactory;

	[Inject]
	public var spec:NoteServiceSpec;

	public var sqlRunner:SQLRunner;

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override protected function activate():void {
		var op:IDeferredOperation = new CreateDataBaseSQLOperation(this, spec);
		deferredOperationManager.add(op);
		op = new SelectNoteKeysSQLOperation(this, sqlFactory, spec.noteClass);
		op.addCompleteCallback(initializeNoteHash);
		deferredOperationManager.add(op);
	}

	public function add(requestMsg:IRequestMessage):void {
		var suite:NoteSuite = requestMsg.data as NoteSuite;
		var op:IDeferredOperation = new InsertNoteSQLOperation(this, suite);
		op.addCompleteCallback(noteAdded);
		requestHandler(requestMsg, op);
		deferredOperationManager.add(op);
	}

	public function update(requestMsg:IRequestMessage):void {
		var suite:NoteSuite = requestMsg.data as NoteSuite;
		var op:IDeferredOperation = new UpdateNoteSQLOperation(this, suite);
		op.addCompleteCallback(noteUpdated);
		requestHandler(requestMsg, op);
		deferredOperationManager.add(op);
	}

	public function remove(requestMsg:IRequestMessage):void {
		var suite:NoteSuite = requestMsg.data as NoteSuite;
		var op:IDeferredOperation = new DeleteNoteSQLOperation(this, suite);
		op.addCompleteCallback(noteRemoved);
		requestHandler(requestMsg, op);
		deferredOperationManager.add(op);
	}

	public function loadPageInfo(requestMsg:IRequestMessage = null):void {
		var pageNum:uint;
		if (requestMsg) pageNum = requestMsg.data as uint;
		else if (model.pageInfo) pageNum = model.pageInfo.pageNum;
		else pageNum = 0;

		var pageInfo:PageInfo = new PageInfo();
		pageInfo.pageSize = settingsModel.info.pageSize;
		pageInfo.pageNum = pageNum;
		pageInfo.filter = model.filter;

		var op:IDeferredOperation = new SelectNoteSQLOperation(this, pageInfo, spec.noteClass);
		op.addCompleteCallback(pageInfoLoaded);
		requestHandler(requestMsg, op);
		deferredOperationManager.add(op);
	}

	public function loadThemes(requestMsg:IRequestMessage = null):void {
		var op:IDeferredOperation = new SelectThemeSQLOperation(this);
		op.addCompleteCallback(themesLoaded);
		requestHandler(requestMsg, op);
		deferredOperationManager.add(op);
	}

	public function loadExamples(requestMsg:IRequestMessage):void {
		var noteID:int = requestMsg.data as int;
		var op:IDeferredOperation = new SelectExamplesSQLOperation(this, noteID);
		requestHandler(requestMsg, op);
		deferredOperationManager.add(op);
	}

	public function updateTheme(requestMsg:IRequestMessage):void {
		var op:IDeferredOperation = new UpdateThemeSQLOperation(this, requestMsg.data as Theme);
		op.addCompleteCallback(themesUpdated);
		requestHandler(requestMsg, op);
		deferredOperationManager.add(op);
	}

	public function removeTheme(requestMsg:IRequestMessage):void {
		var op:IDeferredOperation = new DeleteThemeSQLOperation(this, (requestMsg.data as Theme).id);
		op.addCompleteCallback(themesUpdated);
		requestHandler(requestMsg, op);
		deferredOperationManager.add(op);
	}

	public function mergeThemes(requestMsg:IRequestMessage):void {
		var destThemeID:int = (requestMsg.data.destTheme as Theme).id;
		var srcThemeID:int = (requestMsg.data.srcTheme as Theme).id;
		var op:IDeferredOperation = new MergeThemesSQLOperation(this, destThemeID, srcThemeID);
		op.addCompleteCallback(themesUpdated);
		requestHandler(requestMsg, op);
		deferredOperationManager.add(op);
	}

	public function getSelectedThemesID(requestMsg:IRequestMessage):void {
		var noteID:int = (requestMsg.data as Note).id;
		var op:IDeferredOperation = new SelectFilterSQLOperation(this, noteID);
		requestHandler(requestMsg, op);
		deferredOperationManager.add(op);
	}

	public function loadDBInfo(requestMsg:IRequestMessage = null):void {
		var op:IDeferredOperation = new GetDataBaseInfoSQLOperation(this, model.filter);
		op.addCompleteCallback(dbInfoLoaded);
		requestHandler(requestMsg, op);
		deferredOperationManager.add(op);
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Handlers
	//
	//----------------------------------------------------------------------------------------------

	private function requestHandler(msg:IRequestMessage, op:IDeferredOperation):void {
		if (!msg) return;

		op.addCompleteCallback(function (res:CommandResult):void {
			msg.completeSuccess(res);
		});
		op.addErrorCallback(function (exc:CommandException):void {
			msg.completeWithError(exc);
		});
	}

	private function initializeNoteHash(res:CommandResult):void {
		model.noteHash.init(res.data as Array);
	}

	private function noteAdded(res:CommandResult):void {
		loadPageInfo();
		loadThemes();
		loadDBInfo();
		model.noteHash.add((res.data as NoteSuite).note);
	}

	private function noteUpdated(res:CommandResult):void {
		loadPageInfo();
		loadThemes();
		loadDBInfo();
		model.noteHash.update((res.data as NoteSuite).note, (res.data as NoteSuite).origin);
	}

	private function noteRemoved(res:CommandResult):void {
		loadPageInfo();
		loadDBInfo();
		model.noteHash.remove((res.data as NoteSuite).note);
	}

	private function pageInfoLoaded(res:CommandResult):void {
		model.selectedNote = (res.data as IPageInfo).selectedNote;
		model.pageInfo = res.data as PageInfo;
	}

	private function themesLoaded(res:CommandResult):void {
		model.themes = res.data as Array;
	}

	private function themesUpdated(res:CommandResult):void {
		loadThemes();
		model.filter = [];
	}

	private function dbInfoLoaded(res:CommandResult):void {
		model.dataBaseInfo = res.data as NotesInfo;
	}

}
}