package de.dittner.testmyself.backend.op {

import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.model.domain.test.TestTask;
import de.dittner.testmyself.ui.view.test.testing.components.TestPage;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class SelectPageTestTasksOperation extends StorageOperation implements IAsyncCommand {

	public function SelectPageTestTasksOperation(storage:Storage, page:TestPage) {
		super();
		this.storage = storage;
		this.page = page;
	}

	private var storage:Storage;
	private var page:TestPage;

	public function execute():void {
		var sqlParams:Object = {};
		sqlParams.startIndex = page.number * page.size;
		sqlParams.amount = page.size;
		sqlParams.selectedTestID = page.test.id;
		sqlParams.selectedTaskComplexity = page.taskComplexity;
		sqlParams.onlyFailedNotes = page.loadOnlyFailedTestTask ? 1 : 0;

		var sql:String;
		if (page.filter) {
			sqlParams.selectedThemeID = page.filter.id;
			sql = SQLLib.SELECT_FILTERED_PAGE_TEST_TASKS_SQL;
		}
		else {
			sql = SQLLib.SELECT_PAGE_TEST_TASKS_SQL;
		}

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(executeComplete, executeError));
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