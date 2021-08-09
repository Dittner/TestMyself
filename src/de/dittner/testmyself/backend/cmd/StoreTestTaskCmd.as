package de.dittner.testmyself.backend.cmd {

import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.backend.op.StorageOperation;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.model.domain.test.TestTask;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class StoreTestTaskCmd extends StorageOperation implements IAsyncCommand {

	public function StoreTestTaskCmd(storage:Storage, task:TestTask) {
		this.storage = storage;
		this.task = task;
	}

	private var storage:Storage;
	private var task:TestTask;

	public function execute():void {
		if (task && task.test.id != -1 && task.note.id != -1) {
			var sql:String = SQLLib.UPDATE_TEST_TASK_BY_NOTE_ID_SQL;
			var sqlParams:Object = task.serialize();

			var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
			statement.sqlConnection = storage.sqlConnection;
			statement.execute(-1, new Responder(executeComplete, executeError));
		}
		else {
			dispatchError(ErrorCode.EMPTY_TEST_TASK + ": TestTask has no data about test or note");
		}
	}

	private function executeComplete(result:SQLResult):void {
		dispatchSuccess();
	}

}
}