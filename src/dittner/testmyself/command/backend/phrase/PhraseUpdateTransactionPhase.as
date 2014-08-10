package dittner.testmyself.command.backend.phrase {
import com.probertson.data.QueuedStatement;
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.operation.deferredOperation.ErrorCode;
import dittner.testmyself.command.operation.phaseOperation.PhaseOperation;
import dittner.testmyself.command.operation.result.CommandException;
import dittner.testmyself.model.phrase.Phrase;

import flash.data.SQLResult;
import flash.errors.SQLError;

public class PhraseUpdateTransactionPhase extends PhaseOperation {

	[Embed(source="/dittner/testmyself/command/backend/phrase/sql/UpdatePhrase.sql", mimeType="application/octet-stream")]
	private static const UpdatePhraseSQLClass:Class;
	private static const UPDATE_PHRASE_SQL:String = new UpdatePhraseSQLClass();

	public function PhraseUpdateTransactionPhase(sqlRunner:SQLRunner, phrase:Phrase) {
		this.sqlRunner = sqlRunner;
		this.phrase = phrase;
	}

	private var phrase:Phrase;
	private var sqlRunner:SQLRunner;

	override public function execute():void {
		var sqlParams:Object = {};
		sqlParams.origin = phrase.origin;
		sqlParams.translation = phrase.translation;
		sqlParams.audioRecordID = phrase.audioRecordID;
		sqlParams.updatingPhraseID = phrase.id;

		sqlRunner.executeModify(Vector.<QueuedStatement>([new QueuedStatement(UPDATE_PHRASE_SQL, sqlParams)]), executeComplete, executeError);
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
		sqlRunner = null;
	}
}
}
