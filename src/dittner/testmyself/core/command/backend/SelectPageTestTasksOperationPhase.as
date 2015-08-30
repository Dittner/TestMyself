package dittner.testmyself.core.command.backend {

import dittner.testmyself.core.async.AsyncOperation;
import dittner.testmyself.core.async.ICommand;
import dittner.testmyself.core.command.backend.utils.SQLUtils;
import dittner.testmyself.core.model.note.NoteFilter;
import dittner.testmyself.core.model.note.SQLFactory;
import dittner.testmyself.core.model.page.TestPageInfo;
import dittner.testmyself.core.model.test.TestInfo;
import dittner.testmyself.core.model.test.TestTask;

import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class SelectPageTestTasksOperationPhase extends AsyncOperation implements ICommand {

	public function SelectPageTestTasksOperationPhase(conn:SQLConnection, pageInfo:TestPageInfo, sqlFactory:SQLFactory) {
		super();
		this.conn = conn;
		this.pageInfo = pageInfo;
		this.sqlFactory = sqlFactory;
	}

	private var conn:SQLConnection;
	private var pageInfo:TestPageInfo;
	private var sqlFactory:SQLFactory;

	public function execute():void {
		var testInfo:TestInfo = pageInfo.testSpec.info;

		var sqlParams:Object = {};
		sqlParams.startIndex = pageInfo.pageNum * pageInfo.pageSize;
		sqlParams.amount = pageInfo.pageSize;
		sqlParams.selectedTestID = pageInfo.testSpec.info.id;
		sqlParams.onlyFailedNotes = pageInfo.onlyFailedNotes ? 1 : 0;

		var sql:String;
		var filter:NoteFilter = pageInfo.testSpec.filter;
		if (filter.selectedThemes.length > 0) {
			var themes:String = SQLUtils.themesToSqlStr(filter.selectedThemes);
			sql = testInfo.useNoteExample ? sqlFactory.selectFilteredPageTestExampleTasks : sqlFactory.selectFilteredPageTestTasks;
			sql = sql.replace("#filterList", themes);
		}
		else {
			sql = testInfo.useNoteExample ? sqlFactory.selectPageTestExampleTasks : sqlFactory.selectPageTestTasks;
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