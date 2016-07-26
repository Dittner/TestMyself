package de.dittner.testmyself.backend.operation {

import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.SQLUtils;
import de.dittner.testmyself.model.domain.test.Test;
import de.dittner.testmyself.model.domain.test.TestTask;
import de.dittner.testmyself.model.page.TestPageInfo;

import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class SelectPageTestTasksOperationPhase extends AsyncOperation implements IAsyncCommand {

	public function SelectPageTestTasksOperationPhase(conn:SQLConnection, pageInfo:TestPageInfo, sqlFactory:SQLLib) {
		super();
		this.conn = conn;
		this.pageInfo = pageInfo;
		this.sqlFactory = sqlFactory;
	}

	private var conn:SQLConnection;
	private var pageInfo:TestPageInfo;
	private var sqlFactory:SQLLib;

	public function execute():void {
		var testInfo:Test = pageInfo.testSpec.info;

		var sqlParams:Object = {};
		sqlParams.startIndex = pageInfo.pageNum * pageInfo.pageSize;
		sqlParams.amount = pageInfo.pageSize;
		sqlParams.selectedTestID = pageInfo.testSpec.info.id;
		sqlParams.onlyFailedNotes = pageInfo.onlyFailedNotes ? 1 : 0;

		var sql:String;
		var filter:NoteFilter = pageInfo.testSpec.filter;
		if (filter.selectedThemes.length > 0) {
			var themes:String = SQLUtils.themesToSqlStr(filter.selectedThemes);
			sql = testInfo.useExamples ? sqlFactory.selectFilteredPageTestExampleTasks : sqlFactory.selectFilteredPageTestTasks;
			sql = sql.replace("#filterList", themes);
		}
		else {
			sql = testInfo.useExamples ? sqlFactory.selectPageTestExampleTasks : sqlFactory.selectPageTestTasks;
		}

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
		statement.sqlConnection = conn;
		statement.itemClass = TestTask;
		statement.execute(-1, new Responder(executeComplete));

	}

	private function executeComplete(result:SQLResult):void {
		pageInfo.tasks = result.data is Array ? result.data as Array : [];
		dispatchSuccess();
	}

	override public function destroy():void {
		super.destroy();
		pageInfo = null;
		conn = null;
	}
}
}