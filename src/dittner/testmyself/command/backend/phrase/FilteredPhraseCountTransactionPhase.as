package dittner.testmyself.command.backend.phrase {
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.backend.common.SQLUtils;
import dittner.testmyself.command.operation.deferredOperation.ErrorCode;
import dittner.testmyself.command.operation.phaseOperation.PhaseOperation;
import dittner.testmyself.command.operation.result.CommandException;
import dittner.testmyself.model.common.DataBaseInfo;

import flash.data.SQLResult;

public class FilteredPhraseCountTransactionPhase extends PhaseOperation {
	[Embed(source="/dittner/testmyself/command/backend/phrase/sql/SelectCountAllPhrase.sql", mimeType="application/octet-stream")]
	private static const SelectCountAllPhraseSQLClass:Class;
	private static const SELECT_COUNT_ALL_PHRASE_SQL:String = new SelectCountAllPhraseSQLClass();

	[Embed(source="/dittner/testmyself/command/backend/phrase/sql/SelectCountFilteredPhrase.sql", mimeType="application/octet-stream")]
	private static const SelectCountFilteredPhraseSQLClass:Class;
	private static const SELECT_COUNT_FILTERED_PHRASE_SQL:String = new SelectCountFilteredPhraseSQLClass();

	public function FilteredPhraseCountTransactionPhase(sqlRunner:SQLRunner, info:DataBaseInfo, filter:Array) {
		this.sqlRunner = sqlRunner;
		this.info = info;
		this.filter = filter;
	}

	private var info:DataBaseInfo;
	private var sqlRunner:SQLRunner;
	private var filter:Array;

	override public function execute():void {
		if (filter.length > 0) {
			var themes:String = SQLUtils.themesToSqlStr(filter);
			var statement:String = SELECT_COUNT_FILTERED_PHRASE_SQL;
			statement = statement.replace("#filterList", themes);
			sqlRunner.execute(statement, null, executeComplete);
		}
		else {
			sqlRunner.execute(SELECT_COUNT_ALL_PHRASE_SQL, null, executeComplete);
		}
	}

	private function executeComplete(result:SQLResult):void {
		if (result.data && result.data.length > 0) {
			var countData:Object = result.data[0];
			for (var prop:String in countData) {
				info.filteredUnitsAmount = countData[prop] as int;
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
