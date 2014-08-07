package dittner.testmyself.command.sql.phrase {
import com.probertson.data.QueuedStatement;
import com.probertson.data.SQLRunner;

import dittner.testmyself.model.model_internal;
import dittner.testmyself.model.phrase.Phrase;
import dittner.testmyself.command.core.operation.PhaseOperation;
import dittner.testmyself.command.core.operation.SQLErrorCode;

import flash.data.SQLResult;
import flash.errors.SQLError;

use namespace model_internal;

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
			phrase._id = result.lastInsertRowID;
			completeSuccess();
		}
		else completeWithError(SQLErrorCode.TRANS_UNIT_ADDED_WITHOUT_ID);
	}

	private function executeError(error:SQLError):void {
		completeWithError(error.toString());
	}

	override protected function destroy():void {
		super.destroy();
		phrase = null;
		sqlRunner = null;
		sqlStatement = null;
	}
}
}
