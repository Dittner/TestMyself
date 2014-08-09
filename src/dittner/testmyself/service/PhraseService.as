package dittner.testmyself.service {
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.backend.common.exception.CommandException;
import dittner.testmyself.command.backend.phrase.CreatePhraseDataBaseSQLOperation;
import dittner.testmyself.command.backend.phrase.InsertPhraseSQLOperation;
import dittner.testmyself.command.backend.phrase.SelectPhraseSQLOperation;
import dittner.testmyself.command.backend.phrase.SelectPhraseThemeSQLOperation;
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

	private var pendingAddPhrasesRequest:IRequestMessage;
	public function addPhrase(requestMsg:IRequestMessage):void {
		pendingAddPhrasesRequest = requestMsg;
		deferredOperationManager.push(new InsertPhraseSQLOperation(sqlRunner, requestMsg.data.phrase, requestMsg.data.themes, phraseAdded, addPhraseFailed));
	}

	private var pendingPhrasesRequest:IRequestMessage;
	public function getPhrases(requestMsg:IRequestMessage = null):void {
		pendingPhrasesRequest = requestMsg;
		deferredOperationManager.push(new SelectPhraseSQLOperation(sqlRunner, phrasesLoaded));
	}

	private var pendingThemesRequest:IRequestMessage;
	public function getThemes(requestMsg:IRequestMessage = null):void {
		pendingThemesRequest = requestMsg;
		deferredOperationManager.push(new SelectPhraseThemeSQLOperation(sqlRunner, phraseThemesLoaded));
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Handlers
	//
	//----------------------------------------------------------------------------------------------

	private function phrasesLoaded(phrases:Array):void {
		if (pendingPhrasesRequest) {
			pendingPhrasesRequest.completeSuccess(phrases);
			pendingPhrasesRequest = null;
		}
		model.phrases = phrases;
	}

	private function phraseThemesLoaded(themes:Array):void {
		if (pendingThemesRequest) {
			pendingThemesRequest.completeSuccess(themes);
			pendingThemesRequest = null;
		}
		model.themes = themes;
	}

	private function phraseAdded(phrase:Phrase):void {
		if (pendingAddPhrasesRequest) {
			pendingAddPhrasesRequest.completeSuccess(phrase);
			pendingThemesRequest = null;
		}
		reloadData();
	}

	private function addPhraseFailed(msg:CommandException):void {
		if (pendingAddPhrasesRequest) {
			pendingAddPhrasesRequest.completeWithError(msg);
			pendingAddPhrasesRequest = null;
		}
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
