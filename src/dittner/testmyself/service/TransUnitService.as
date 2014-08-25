package dittner.testmyself.service {
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.backend.CreateDataBaseSQLOperation;
import dittner.testmyself.command.backend.DeleteThemeSQLOperation;
import dittner.testmyself.command.backend.DeleteTransUnitSQLOperation;
import dittner.testmyself.command.backend.GetDataBaseInfoOperation;
import dittner.testmyself.command.backend.InsertTransUnitSQLOperation;
import dittner.testmyself.command.backend.MergeThemesSQLOperation;
import dittner.testmyself.command.backend.SelectFilterSQLOperation;
import dittner.testmyself.command.backend.SelectThemeSQLOperation;
import dittner.testmyself.command.backend.SelectTransUnitSQLOperation;
import dittner.testmyself.command.backend.UpdateThemeSQLOperation;
import dittner.testmyself.command.backend.UpdateTransUnitSQLOperation;
import dittner.testmyself.command.backend.deferredOperation.IDeferredOperation;
import dittner.testmyself.command.backend.deferredOperation.IDeferredOperationManager;
import dittner.testmyself.command.backend.result.CommandException;
import dittner.testmyself.command.backend.result.CommandResult;
import dittner.testmyself.model.common.DataBaseInfo;
import dittner.testmyself.model.common.IPageInfo;
import dittner.testmyself.model.common.ITransUnitModel;
import dittner.testmyself.model.common.PageInfo;
import dittner.testmyself.model.common.TransUnit;
import dittner.testmyself.model.settings.SettingsModel;
import dittner.testmyself.model.theme.Theme;
import dittner.testmyself.view.common.mediator.IRequestMessage;

import mvcexpress.mvc.Proxy;

public class TransUnitService extends Proxy {

	public function TransUnitService(model:ITransUnitModel) {
		this.model = model;
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Variables
	//
	//----------------------------------------------------------------------------------------------

	[Inject]
	public var deferredOperationManager:IDeferredOperationManager;

	[Inject]
	public var settings:SettingsModel;

	public var sqlRunner:SQLRunner;

	private var model:ITransUnitModel;

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override protected function onRegister():void {
		var op:IDeferredOperation = new CreateDataBaseSQLOperation(this, model.dbName, model.sqlFactory);
		deferredOperationManager.add(op);
	}

	public function add(requestMsg:IRequestMessage):void {
		var op:IDeferredOperation = new InsertTransUnitSQLOperation(sqlRunner, requestMsg.data.transUnit, requestMsg.data.themes, model.sqlFactory);
		op.addCompleteCallback(transUnitAdded);
		requestHandler(requestMsg, op);
		deferredOperationManager.add(op);
	}

	public function update(requestMsg:IRequestMessage):void {
		var op:IDeferredOperation = new UpdateTransUnitSQLOperation(sqlRunner, requestMsg.data.transUnit, requestMsg.data.origin, requestMsg.data.themes, model.sqlFactory);
		op.addCompleteCallback(transUnitUpdated);
		requestHandler(requestMsg, op);
		deferredOperationManager.add(op);
	}

	public function remove(requestMsg:IRequestMessage):void {
		var op:IDeferredOperation = new DeleteTransUnitSQLOperation(sqlRunner, (requestMsg.data as TransUnit).id, model.sqlFactory);
		op.addCompleteCallback(transUnitRemoved);
		requestHandler(requestMsg, op);
		deferredOperationManager.add(op);
	}

	public function loadPageInfo(requestMsg:IRequestMessage = null):void {
		var pageNum:uint;
		if (requestMsg) pageNum = requestMsg.data as uint;
		else if (model.pageInfo) pageNum = model.pageInfo.pageNum;
		else pageNum = 0;

		var pageInfo:PageInfo = new PageInfo();
		pageInfo.pageSize = settings.info.pageSize;
		pageInfo.pageNum = pageNum;
		pageInfo.filter = model.filter;

		var op:IDeferredOperation = new SelectTransUnitSQLOperation(sqlRunner, pageInfo, model.transUnitClass, model.sqlFactory);
		op.addCompleteCallback(pageInfoLoaded);
		requestHandler(requestMsg, op);
		deferredOperationManager.add(op);
	}

	public function loadThemes(requestMsg:IRequestMessage = null):void {
		var op:IDeferredOperation = new SelectThemeSQLOperation(sqlRunner, model.sqlFactory);
		op.addCompleteCallback(themesLoaded);
		requestHandler(requestMsg, op);
		deferredOperationManager.add(op);
	}

	public function updateTheme(requestMsg:IRequestMessage):void {
		var op:IDeferredOperation = new UpdateThemeSQLOperation(sqlRunner, requestMsg.data as Theme, model.sqlFactory);
		op.addCompleteCallback(themesUpdated);
		requestHandler(requestMsg, op);
		deferredOperationManager.add(op);
	}

	public function removeTheme(requestMsg:IRequestMessage):void {
		var op:IDeferredOperation = new DeleteThemeSQLOperation(sqlRunner, (requestMsg.data as Theme).id, model.sqlFactory);
		op.addCompleteCallback(themesUpdated);
		requestHandler(requestMsg, op);
		deferredOperationManager.add(op);
	}

	public function mergeThemes(requestMsg:IRequestMessage):void {
		var destThemeID:int = (requestMsg.data.destTheme as Theme).id;
		var srcThemeID:int = (requestMsg.data.srcTheme as Theme).id;
		var op:IDeferredOperation = new MergeThemesSQLOperation(sqlRunner, destThemeID, srcThemeID, model.sqlFactory);
		op.addCompleteCallback(themesUpdated);
		requestHandler(requestMsg, op);
		deferredOperationManager.add(op);
	}

	public function getSelectedThemesID(requestMsg:IRequestMessage):void {
		var transUnitID:int = (requestMsg.data as TransUnit).id;
		var op:IDeferredOperation = new SelectFilterSQLOperation(sqlRunner, transUnitID, model.sqlFactory);
		requestHandler(requestMsg, op);
		deferredOperationManager.add(op);
	}

	public function loadDBInfo(requestMsg:IRequestMessage = null):void {
		var op:IDeferredOperation = new GetDataBaseInfoOperation(sqlRunner, model.filter, model.sqlFactory);
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

	private function transUnitAdded(res:CommandResult):void {
		loadPageInfo();
		loadThemes();
		loadDBInfo();
	}

	private function transUnitUpdated(res:CommandResult):void {
		loadPageInfo();
		loadThemes();
		loadDBInfo();
	}

	private function transUnitRemoved(res:CommandResult):void {
		loadPageInfo();
		loadDBInfo();
	}

	private function pageInfoLoaded(res:CommandResult):void {
		model.selectedTransUnit = (res.data as IPageInfo).selectedTransUnit;
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
		model.dataBaseInfo = res.data as DataBaseInfo;
	}

}
}