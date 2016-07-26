package de.dittner.testmyself.backend.cmd {

import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.backend.SQLUtils;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogCategory;
import de.dittner.testmyself.model.domain.test.TestTask;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;

public class StoreTestTaskCmd extends AsyncOperation implements IAsyncCommand {

	public function StoreTestTaskCmd(storage:SQLStorage, task:TestTask) {
		this.storage = storage;
		this.task = task;
	}

	private var storage:SQLStorage;
	private var task:TestTask;

	public function execute():void {
		if (task && task.test.id != -1 && task.note.id != -1) {
			var sql:String = SQLLib.UPDATE_TEST_TASK_SQL;
			var sqlParams:Object = task.serialize();

			var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
			statement.sqlConnection = storage.sqlConnection;
			statement.execute(-1, new Responder(executeComplete, executeError));
		}
		else {
			CLog.err(LogCategory.STORAGE, ErrorCode.EMPTY_TEST_TASK + ": TestTask has no data about test or note");
			dispatchError(ErrorCode.EMPTY_TEST_TASK);
		}
	}

	private function executeComplete(result:SQLResult):void {
		dispatchSuccess();
	}

	private function executeError(error:SQLError):void {
		CLog.err(LogCategory.STORAGE, ErrorCode.SQL_TRANSACTION_FAILED + ": " + error.details);
		dispatchError(ErrorCode.SQL_TRANSACTION_FAILED);
	}

}
}