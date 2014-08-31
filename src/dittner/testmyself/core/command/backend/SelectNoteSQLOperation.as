package dittner.testmyself.core.command.backend {
import com.probertson.data.SQLRunner;

import dittner.satelliteFlight.command.CommandResult;
import dittner.testmyself.core.command.backend.deferredOperation.DeferredOperation;
import dittner.testmyself.core.command.backend.utils.SQLFactory;
import dittner.testmyself.core.command.backend.utils.SQLUtils;
import dittner.testmyself.core.model.page.PageInfo;

import flash.data.SQLResult;

public class SelectNoteSQLOperation extends DeferredOperation {

	public function SelectNoteSQLOperation(sqlRunner:SQLRunner, pageInfo:PageInfo, noteClass:Class, sqlFactory:SQLFactory) {
		super();
		this.sqlRunner = sqlRunner;
		this.pageInfo = pageInfo;
		this.sqlFactory = sqlFactory;
		this.noteClass = noteClass;
	}

	private var sqlRunner:SQLRunner;
	private var pageInfo:PageInfo;
	private var noteClass:Class;
	private var sqlFactory:SQLFactory;

	override public function process():void {
		var params:Object = {};
		params.startIndex = pageInfo.pageNum * pageInfo.pageSize;
		params.amount = pageInfo.pageSize;

		if (pageInfo.filter.length > 0) {
			var themes:String = SQLUtils.themesToSqlStr(pageInfo.filter);
			var statement:String = sqlFactory.selectFilteredNote;
			statement = statement.replace("#filterList", themes);
			sqlRunner.execute(statement, params, loadedHandler, noteClass);
		}
		else {
			sqlRunner.execute(sqlFactory.selectNote, params, loadedHandler, noteClass);
		}
	}

	private function loadedHandler(result:SQLResult):void {
		pageInfo.notes = result.data is Array ? result.data as Array : [];
		dispatchCompleteSuccess(new CommandResult(pageInfo));
	}
}
}