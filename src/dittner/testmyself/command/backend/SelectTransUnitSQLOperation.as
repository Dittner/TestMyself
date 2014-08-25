package dittner.testmyself.command.backend {
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.backend.deferredOperation.DeferredOperation;
import dittner.testmyself.command.backend.result.CommandResult;
import dittner.testmyself.command.backend.utils.SQLFactory;
import dittner.testmyself.command.backend.utils.SQLUtils;
import dittner.testmyself.model.common.PageInfo;

import flash.data.SQLResult;

public class SelectTransUnitSQLOperation extends DeferredOperation {

	public function SelectTransUnitSQLOperation(sqlRunner:SQLRunner, pageInfo:PageInfo, transUnitClass:Class, sqlFactory:SQLFactory) {
		super();
		this.sqlRunner = sqlRunner;
		this.pageInfo = pageInfo;
		this.sqlFactory = sqlFactory;
		this.transUnitClass = transUnitClass;
	}

	private var sqlRunner:SQLRunner;
	private var pageInfo:PageInfo;
	private var transUnitClass:Class;
	private var sqlFactory:SQLFactory;

	override public function process():void {
		var params:Object = {};
		params.startIndex = pageInfo.pageNum * pageInfo.pageSize;
		params.amount = pageInfo.pageSize;

		if (pageInfo.filter.length > 0) {
			var themes:String = SQLUtils.themesToSqlStr(pageInfo.filter);
			var statement:String = sqlFactory.selectFilteredTransUnit;
			statement = statement.replace("#filterList", themes);
			sqlRunner.execute(statement, params, loadedHandler, transUnitClass);
		}
		else {
			sqlRunner.execute(sqlFactory.selectTransUnit, params, loadedHandler, transUnitClass);
		}
	}

	private function loadedHandler(result:SQLResult):void {
		pageInfo.transUnits = result.data is Array ? result.data as Array : [];
		dispatchCompleteSuccess(new CommandResult(pageInfo));
	}
}
}