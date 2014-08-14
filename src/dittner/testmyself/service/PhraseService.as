package dittner.testmyself.service {
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.backend.phrase.CreatePhraseDataBaseSQLOperation;
import dittner.testmyself.command.backend.phrase.DeletePhraseSQLOperation;
import dittner.testmyself.command.backend.phrase.InsertPhraseSQLOperation;
import dittner.testmyself.command.backend.phrase.SelectPhraseFilterSQLOperation;
import dittner.testmyself.command.backend.phrase.SelectPhraseSQLOperation;
import dittner.testmyself.command.backend.phrase.SelectPhraseThemeSQLOperation;
import dittner.testmyself.command.backend.phrase.UpdatePhraseSQLOperation;
import dittner.testmyself.command.operation.deferredOperation.IDeferredOperation;
import dittner.testmyself.command.operation.deferredOperation.IDeferredOperationManager;
import dittner.testmyself.command.operation.result.CommandException;
import dittner.testmyself.command.operation.result.CommandResult;
import dittner.testmyself.model.phrase.Phrase;
import dittner.testmyself.model.phrase.PhraseModel;
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

	public function getPhrases(requestMsg:IRequestMessage = null):void {
		var op:IDeferredOperation = new SelectPhraseSQLOperation(sqlRunner);
		op.addCompleteCallback(phrasesLoaded);
		requestHandler(requestMsg, op);
		deferredOperationManager.add(op);
	}

	public function getThemes(requestMsg:IRequestMessage = null):void {
		var op:IDeferredOperation = new SelectPhraseThemeSQLOperation(sqlRunner);
		op.addCompleteCallback(phraseThemesLoaded);
		requestHandler(requestMsg, op);
		deferredOperationManager.add(op);
	}

	public function getSelectedThemesID(requestMsg:IRequestMessage):void {
		var op:IDeferredOperation = new SelectPhraseFilterSQLOperation(sqlRunner, (requestMsg.data as Phrase).id);
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
		reloadData();

	}
	private function phraseUpdated(res:CommandResult):void {
		reloadData();
	}

	private function phraseRemoved(res:CommandResult):void {
		reloadData();
	}

	private function phrasesLoaded(res:CommandResult):void {
		res.data.reverse();
		model.phrases = res.data as Array;
	}

	private function phraseThemesLoaded(res:CommandResult):void {
		model.themes = res.data as Array;
	}

	private function reloadData():void {
		getPhrases();
		getThemes();
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