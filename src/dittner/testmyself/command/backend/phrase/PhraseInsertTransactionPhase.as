package dittner.testmyself.command.backend.phrase {
import com.probertson.data.QueuedStatement;
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.backend.common.exception.CommandException;
import dittner.testmyself.command.core.deferredOperation.ErrorCode;
import dittner.testmyself.command.core.phaseOperation.PhaseOperation;
import dittner.testmyself.model.phrase.Phrase;

import flash.data.SQLResult;
import flash.errors.SQLError;

public class PhraseInsertTransactionPhase extends PhaseOperation {
	public function PhraseInsertTransactionPhase(phrase:Phrase, sqlRunner:SQLRunner, sqlStatement:String) {
		this.phrase = phrase;
		this.sqlRunner = sqlRunner;
		this.sqlStatement = sqlStatement;
	}

	private var phrase:Phrase;
	private var sqlRunner:SQLRunner;
	private var sqlStatement:String;

	override public function execute():void {
		var sqlParams:Object = {};
		sqlParams.origin = phrase.origin;
		sqlParams.translation = phrase.translation;
		sqlParams.audioRecordID = phrase.audioRecordID;

		sqlRunner.executeModify(Vector.<QueuedStatement>([new QueuedStatement(sqlStatement, sqlParams)]), executeComplete, executeError);
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
		sqlStatement = null;
	}
}
}
