package dittner.testmyself.service {
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.backend.common.exception.CommandException;
import dittner.testmyself.command.backend.phrase.CreatePhraseDataBaseSQLOperation;
import dittner.testmyself.command.backend.phrase.DeletePhraseSQLOperation;
import dittner.testmyself.command.backend.phrase.InsertPhraseSQLOperation;
import dittner.testmyself.command.backend.phrase.SelectPhraseSQLOperation;
import dittner.testmyself.command.backend.phrase.SelectPhraseThemeSQLOperation;
import dittner.testmyself.command.core.deferredOperation.IDeferredOperation;
import dittner.testmyself.command.core.deferredOperation.IDeferredOperationManager;
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
		deferredOperationManager.push(new CreatePhraseDataBaseSQLOperation(this));
	}

	public function addPhrase(requestMsg:IRequestMessage):void {
		var op:IDeferredOperation = new InsertPhraseSQLOperation(sqlRunner, requestMsg.data.phrase, requestMsg.data.themes);
		op.addCompleteCallback(phraseAdded);
		requestHandler(requestMsg, op);
		deferredOperationManager.push(op);
	}

	public function removePhrase(requestMsg:IRequestMessage):void {
		var op:IDeferredOperation = new DeletePhraseSQLOperation(sqlRunner, requestMsg.data as Phrase);
		op.addCompleteCallback(phraseRemoved);
		requestHandler(requestMsg, op);
		deferredOperationManager.push(op);
	}

	public function getPhrases(requestMsg:IRequestMessage = null):void {
		var op:IDeferredOperation = new SelectPhraseSQLOperation(sqlRunner);
		op.addCompleteCallback(phrasesLoaded);
		requestHandler(requestMsg, op);
		deferredOperationManager.push(op);
	}

	public function getThemes(requestMsg:IRequestMessage = null):void {
		var op:IDeferredOperation = new SelectPhraseThemeSQLOperation(sqlRunner);
		op.addCompleteCallback(phraseThemesLoaded);
		requestHandler(requestMsg, op);
		deferredOperationManager.push(op);
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Handlers
	//
	//----------------------------------------------------------------------------------------------

	private function requestHandler(msg:IRequestMessage, op:IDeferredOperation):void {
		if (!msg) return;

		op.addCompleteCallback(function (res:Object):void {
			msg.completeSuccess(res);
		});
		op.addErrorCallback(function (exc:CommandException):void {
			msg.completeWithError(exc);
		});
	}

	private function phraseAdded(phrase:Phrase):void {
		reloadData();
	}

	private function phraseRemoved(result:*):void {
		reloadData();
	}

	private function phrasesLoaded(phrases:Array):void {
		if (phrases) phrases.reverse();
		model.phrases = phrases;
	}

	private function phraseThemesLoaded(themes:Array):void {
		model.themes = themes;
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