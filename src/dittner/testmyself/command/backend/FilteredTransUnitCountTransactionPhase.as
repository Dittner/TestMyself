package dittner.testmyself.command.backend {
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.command.backend.phaseOperation.PhaseOperation;
import dittner.testmyself.command.backend.result.CommandException;
import dittner.testmyself.command.backend.utils.SQLFactory;
import dittner.testmyself.command.backend.utils.SQLUtils;
import dittner.testmyself.model.common.DataBaseInfo;

import flash.data.SQLResult;

public class FilteredTransUnitCountTransactionPhase extends PhaseOperation {

	public function FilteredTransUnitCountTransactionPhase(sqlRunner:SQLRunner, info:DataBaseInfo, filter:Array, sqlFactory:SQLFactory) {
		this.sqlRunner = sqlRunner;
		this.info = info;
		this.filter = filter;
		this.sqlFactory = sqlFactory;
	}

	private var info:DataBaseInfo;
	private var sqlRunner:SQLRunner;
	private var filter:Array;
	private var sqlFactory:SQLFactory;

	override public function execute():void {
		if (filter.length > 0) {
			var themes:String = SQLUtils.themesToSqlStr(filter);
			var statement:String = sqlFactory.selectCountFilteredTransUnit;
			statement = statement.replace("#filterList", themes);
			sqlRunner.execute(statement, null, executeComplete);
		}
		else {
			sqlRunner.execute(sqlFactory.selectCountTransUnit, null, executeComplete);
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
			throw new CommandException(ErrorCode.SQL_TRANSACTION_FAILED, "Не удалось получить число единиц перевода в таблице");
		}
	}

	override public function destroy():void {
		super.destroy();
		info = null;
		sqlRunner = null;
	}
}
}
