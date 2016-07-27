package de.dittner.testmyself.backend.op {
import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogCategory;
import de.dittner.testmyself.ui.view.test.testing.components.TestPageInfo;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class CountTestTasksOperation extends AsyncOperation implements IAsyncCommand {

	public function CountTestTasksOperation(storage:SQLStorage, page:TestPageInfo) {
		super();
		this.storage = storage;
		this.page = page;
	}

	private var storage:SQLStorage;
	private var page:TestPageInfo;

	public function execute():void {
		var sqlParams:Object = {};
		sqlParams.selectedTestID = page.test.id;
		sqlParams.onlyFailedNotes = page.onlyFailedNotes ? 1 : 0;

		var sql:String;
		if (page.selectedTheme) {
			sqlParams.selectedThemeID = page.selectedTheme.id;
			sql = SQLLib.SELECT_COUNT_FILTERED_TEST_TASK_SQL;
		}
		else {
			sql = SQLLib.SELECT_COUNT_TEST_TASK_SQL;
		}

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(executeComplete));

	}

	private function executeComplete(result:SQLResult):void {
		if (result.data && result.data.length > 0) {
			var countData:Object = result.data[0];
			for (var prop:String in countData) {
				page.amountAllTasks = countData[prop] as int;
				break;
			}
			dispatchSuccess();
		}
		else {
			CLog.err(LogCategory.STORAGE, ErrorCode.SQL_TRANSACTION_FAILED + ": Не удалось получить число тесовых задач в таблице");
			dispatchError(ErrorCode.SQL_TRANSACTION_FAILED);
		}
	}

	override public function destroy():void {
		super.destroy();
		storage = null;
		page = null;
	}
}
}