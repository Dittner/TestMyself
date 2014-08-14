package dittner.testmyself.command.backend.phrase {
import com.probertson.data.QueuedStatement;
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.operation.deferredOperation.ErrorCode;
import dittner.testmyself.command.operation.phaseOperation.PhaseOperation;
import dittner.testmyself.command.operation.result.CommandException;

import flash.data.SQLResult;
import flash.errors.SQLError;

public class DeletePhraseFilterTransactionPhase extends PhaseOperation {

	[Embed(source="/dittner/testmyself/command/backend/phrase/sql/DeletePhraseFilter.sql", mimeType="application/octet-stream")]
	private static const DeletePhraseFilterSQLClass:Class;
	private static const DELETE_PHRASE_FILTER_SQL:String = new DeletePhraseFilterSQLClass();

	public function DeletePhraseFilterTransactionPhase(sqlRunner:SQLRunner, phraseID:int) {
		super();
		this.sqlRunner = sqlRunner;
		this.phraseID = phraseID;
	}

	private var sqlRunner:SQLRunner;
	private var phraseID:int;

	override public function execute():void {
		if (phraseID) {
			var statements:Vector.<QueuedStatement> = new <QueuedStatement>[];
			statements.push(new QueuedStatement(DELETE_PHRASE_FILTER_SQL, {deletingPhraseID: phraseID}));
			sqlRunner.executeModify(statements, deleteCompleteHandler, deleteFailedHandler);
		}
		else throw new CommandException(ErrorCode.NULL_TRANS_UNIT, "Отсутствует ID фразы");
	}

	private function deleteCompleteHandler(results:Vector.<SQLResult>):void {
		dispatchComplete();
	}

	private function deleteFailedHandler(error:SQLError):void {
		throw new CommandException(ErrorCode.SQL_TRANSACTION_FAILED, error.details);
	}

	override public function destroy():void {
		super.destroy();
		sqlRunner = null;
	}
}
}