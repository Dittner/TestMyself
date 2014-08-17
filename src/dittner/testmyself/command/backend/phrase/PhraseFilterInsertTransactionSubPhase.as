package dittner.testmyself.command.backend.phrase {

import com.probertson.data.QueuedStatement;
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.operation.deferredOperation.ErrorCode;
import dittner.testmyself.command.operation.phaseOperation.PhaseOperation;
import dittner.testmyself.command.operation.result.CommandException;
import dittner.testmyself.model.phrase.Phrase;
import dittner.testmyself.model.theme.Theme;

import flash.data.SQLResult;
import flash.errors.SQLError;

public class PhraseFilterInsertTransactionSubPhase extends PhaseOperation {
	public function PhraseFilterInsertTransactionSubPhase(phrase:Phrase, theme:Theme, sqlRunner:SQLRunner, sqlStatement:String) {
		this.phrase = phrase;
		this.theme = theme;
		this.sqlRunner = sqlRunner;
		this.sqlStatement = sqlStatement;
	}

	private var phrase:Phrase;
	private var theme:Theme;
	private var sqlRunner:SQLRunner;
	private var sqlStatement:String;

	override public function execute():void {
		var statements:Vector.<QueuedStatement> = new Vector.<QueuedStatement>();
		var sqlParams:Object = {};
		sqlParams.phraseID = phrase.id;
		sqlParams.themeID = theme.id;

		statements.push(new QueuedStatement(sqlStatement, sqlParams));
		sqlRunner.executeModify(statements, executeComplete, executeError);
	}

	private function executeComplete(results:Vector.<SQLResult>):void {
		dispatchComplete();
	}

	private function executeError(error:SQLError):void {
		throw new CommandException(ErrorCode.SQL_TRANSACTION_FAILED, error.details);
	}

	override public function destroy():void {
		super.destroy();
		phrase = null;
		theme = null;
		sqlRunner = null;
		sqlStatement = null;
	}
}
}