package dittner.testmyself.service {
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.backend.phrase.CreatePhraseDataBaseSQLOperation;
import dittner.testmyself.command.backend.phrase.DeletePhraseSQLOperation;
import dittner.testmyself.command.backend.phrase.GetPhraseDBInfoOperation;
import dittner.testmyself.command.backend.phrase.InsertPhraseSQLOperation;
import dittner.testmyself.command.backend.phrase.SelectPhraseFilterSQLOperation;
import dittner.testmyself.command.backend.phrase.SelectPhraseSQLOperation;
import dittner.testmyself.command.backend.phrase.SelectPhraseThemeSQLOperation;
import dittner.testmyself.command.backend.phrase.UpdatePhraseSQLOperation;
import dittner.testmyself.command.operation.deferredOperation.IDeferredOperation;
import dittner.testmyself.command.operation.deferredOperation.IDeferredOperationManager;
import dittner.testmyself.command.operation.result.CommandException;
import dittner.testmyself.command.operation.result.CommandResult;
import dittner.testmyself.model.common.DataBaseInfo;
import dittner.testmyself.model.common.SettingsModel;
import dittner.testmyself.model.phrase.Phrase;
import dittner.testmyself.model.phrase.PhraseModel;
import dittner.testmyself.model.phrase.PhrasePageInfo;
import dittner.testmyself.view.common.mediator.IRequestMessage;

import mvcexpress.mvc.Proxy;

public class PhraseService extends Proxy {

	public function PhraseService() {
		super();
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

	[Inject]
	public var model:PhraseModel;

	public var sqlRunner:SQLRunner;
	public function get isDataBaseCreated():Boolean {return sqlRunner != null;}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	private function createDB():void {
		deferredOperationManager.add(new CreatePhraseDataBaseSQLOperation(this));
	}

	public function addPhrase(requestMsg:IRequestMessage):void {
		var op:IDeferredOperation = new InsertPhraseSQLOperation(sqlRunner, requestMsg.data.phrase, requestMsg.data.themes);
		op.addCompleteCallback(phraseAdded);
		requestHandler(requestMsg, op);
		deferredOperationManager.add(op);
	}

	public function updatePhrase(requestMsg:IRequestMessage):void {
		var op:IDeferredOperation = new UpdatePhraseSQLOperation(sqlRunner, requestMsg.data.phrase, requestMsg.data.origin, requestMsg.data.themes);
		op.addCompleteCallback(phraseUpdated);
		requestHandler(requestMsg, op);
		deferredOperationManager.add(op);
	}

	public function removePhrase(requestMsg:IRequestMessage):void {
		var op:IDeferredOperation = new DeletePhraseSQLOperation(sqlRunner, (requestMsg.data as Phrase).id);
		op.addCompleteCallback(phraseRemoved);
		requestHandler(requestMsg, op);
		deferredOperationManager.add(op);
	}

	public function loadPageInfo(requestMsg:IRequestMessage = null):void {
		var pageNum:uint;
		if (requestMsg) pageNum = requestMsg.data as uint;
		else if (model.pageInfo) pageNum = model.pageInfo.pageNum;
		else pageNum = 0;

		var pageInfo:PhrasePageInfo = new PhrasePageInfo();
		pageInfo.pageSize = settings.info.pageSize;
		pageInfo.pageNum = pageNum;
		pageInfo.filter = model.filter;

		var op:IDeferredOperation = new SelectPhraseSQLOperation(sqlRunner, pageInfo);
		op.addCompleteCallback(pageInfoLoaded);
		requestHandler(requestMsg, op);
		deferredOperationManager.add(op);
	}

	public function loadThemes(requestMsg:IRequestMessage = null):void {
		var op:IDeferredOperation = new SelectPhraseThemeSQLOperation(sqlRunner);
		op.addCompleteCallback(themesLoaded);
		requestHandler(requestMsg, op);
		deferredOperationManager.add(op);
	}

	public function getSelectedThemesID(requestMsg:IRequestMessage):void {
		var op:IDeferredOperation = new SelectPhraseFilterSQLOperation(sqlRunner, (requestMsg.data as Phrase).id);
		requestHandler(requestMsg, op);
		deferredOperationManager.add(op);
	}

	public function loadDBInfo(requestMsg:IRequestMessage = null):void {
		var op:IDeferredOperation = new GetPhraseDBInfoOperation(sqlRunner, model.filter);
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

	private function phraseAdded(res:CommandResult):void {
		loadPageInfo();
		loadThemes();
		loadDBInfo();
	}

	private function phraseUpdated(res:CommandResult):void {
		loadPageInfo();
		loadThemes();
		loadDBInfo();
	}

	private function phraseRemoved(res:CommandResult):void {
		loadPageInfo();
		loadDBInfo();
	}

	private function pageInfoLoaded(res:CommandResult):void {
		model.selectedPhrase = (res.data as PhrasePageInfo).selectedPhrase;
		model.pageInfo = res.data as PhrasePageInfo;
	}

	private function themesLoaded(res:CommandResult):void {
		model.themes = res.data as Array;
	}

	private function dbInfoLoaded(res:CommandResult):void {
		model.dataBaseInfo = res.data as DataBaseInfo;
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Overriden
	//
	//----------------------------------------------------------------------------------------------

	override protected function onRegister():void {
		if (!isDataBaseCreated) createDB();
	}

	override protected function onRemove():void {
		sqlRunner.close(resultHandler);
	}

	private function resultHandler():void {}

}
}