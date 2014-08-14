package dittner.testmyself.command.backend.phrase {
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.operation.deferredOperation.ErrorCode;
import dittner.testmyself.command.operation.phaseOperation.PhaseOperation;
import dittner.testmyself.command.operation.result.CommandException;
import dittner.testmyself.model.common.DataBaseInfo;

import flash.data.SQLResult;

public class PhraseCountTransactionPhase extends PhaseOperation {

	[Embed(source="/dittner/testmyself/command/backend/phrase/sql/SelectCountAllPhrase.sql", mimeType="application/octet-stream")]
	private static const SelectCountAllPhraseSQLClass:Class;
	private static const SELECT_COUNT_ALL_PHRASE_SQL:String = new SelectCountAllPhraseSQLClass();

	public function PhraseCountTransactionPhase(sqlRunner:SQLRunner, info:DataBaseInfo) {
		this.sqlRunner = sqlRunner;
		this.info = info;
	}

	private var info:DataBaseInfo;
	private var sqlRunner:SQLRunner;

	override public function execute():void {
		sqlRunner.execute(SELECT_COUNT_ALL_PHRASE_SQL, null, executeComplete);
	}

	private function executeComplete(result:SQLResult):void {
		if (result.data && result.data.length > 0) {
			var countData:Object = result.data[0];
			for (var prop:String in countData) {
				info.unitsAmount = countData[prop] as int;
				break;
			}
			dispatchComplete();
		}
		else {
			throw new CommandException(ErrorCode.SQL_TRANSACTION_FAILED, "Не удалось получить число фраз в таблице");
		}
	}

	override public function destroy():void {
		super.destroy();
		info = null;
		sqlRunner = null;
	}
}
}
