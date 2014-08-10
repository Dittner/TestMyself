package dittner.testmyself.command.backend.phrase {
import com.probertson.data.QueuedStatement;
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.operation.deferredOperation.ErrorCode;
import dittner.testmyself.command.operation.phaseOperation.PhaseOperation;
import dittner.testmyself.command.operation.result.CommandException;
import dittner.testmyself.model.phrase.Phrase;

import flash.data.SQLResult;
import flash.errors.SQLError;

public class PhraseInsertTransactionPhase extends PhaseOperation {

	[Embed(source="/dittner/testmyself/command/backend/phrase/sql/InsertPhrase.sql", mimeType="application/octet-stream")]
	private static const InsertPhraseSQLClass:Class;
	private static const INSERT_PHRASE_SQL:String = new InsertPhraseSQLClass();

	public function PhraseInsertTransactionPhase(sqlRunner:SQLRunner, phrase:Phrase) {
		this.sqlRunner = sqlRunner;
		this.phrase = phrase;
	}

	private var phrase:Phrase;
	private var sqlRunner:SQLRunner;

	override public function execute():void {
		var sqlParams:Object = {};
		sqlParams.origin = phrase.origin;
		sqlParams.translation = phrase.translation;
		sqlParams.audioRecord = phrase.audioRecord;

		sqlRunner.executeModify(Vector.<QueuedStatement>([new QueuedStatement(INSERT_PHRASE_SQL, sqlParams)]), executeComplete, executeError);
	}

	private function executeComplete(results:Vector.<SQLResult>):void {
		var result:SQLResult = results[0];
		if (result.rowsAffected > 0) {
			phrase.id = result.lastInsertRowID;
			dispatchComplete();
		}
		else {
			throw new CommandException(ErrorCode.TRANS_UNIT_ADDED_WITHOUT_ID, "База данных не вернула ID добавленной фразы");
		}
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
