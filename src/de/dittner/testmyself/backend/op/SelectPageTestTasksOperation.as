package de.dittner.testmyself.backend.op {

import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.model.domain.test.TestTask;
import de.dittner.testmyself.ui.view.test.testing.components.TestPageInfo;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class SelectPageTestTasksOperation extends AsyncOperation implements IAsyncCommand {

	public function SelectPageTestTasksOperation(storage:SQLStorage, page:TestPageInfo) {
		super();
		this.storage = storage;
		this.page = page;
	}

	private var storage:SQLStorage;
	private var page:TestPageInfo;

	public function execute():void {
		var sqlParams:Object = {};
		sqlParams.startIndex = page.pageNum * page.pageSize;
		sqlParams.amount = page.pageSize;
		sqlParams.selectedTestID = page.test.id;
		sqlParams.onlyFailedNotes = page.onlyFailedNotes ? 1 : 0;

		var sql:String;
		if (page.selectedTheme) {
			sqlParams.selectedThemeID = page.selectedTheme.id;
			sql = SQLLib.SELECT_FILTERED_PAGE_TEST_TASKS_SQL;
		}
		else {
			sql = SQLLib.SELECT_PAGE_TEST_TASKS_SQL;
		}

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(executeComplete));
	}

	private function executeComplete(result:SQLResult):void {
		var tasks:Array = [];
		if (result.data is Array)
			for each(var item:Object in result.data) {
				var task:TestTask = page.test.createTestTask();
				task.deserialize(item);
				tasks.push(task);
			}

		page.tasks = tasks;
		dispatchSuccess();
	}

	override public function destroy():void {
		super.destroy();
		storage = null;
		page = null;
	}
}
}