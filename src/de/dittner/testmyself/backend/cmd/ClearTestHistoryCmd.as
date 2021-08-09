package de.dittner.testmyself.backend.cmd {
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.backend.op.StorageOperation;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.model.domain.test.Test;
import de.dittner.testmyself.model.domain.test.TestTaskPriority;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class ClearTestHistoryCmd extends StorageOperation implements IAsyncCommand {
	public function ClearTestHistoryCmd(storage:Storage, test:Test) {
		this.storage = storage;
		this.test = test;
	}

	private var storage:Storage;
	private var test:Test;

	public function execute():void {
		if (!test || !test.id == -1) {
			dispatchError(ErrorCode.NOTE_OF_TEST_TASK_HAS_NO_ID + ": Нет ID теста, необходимого для удаления результатов теста");
			return;
		}

		selectAllTaskIDs();
	}

	private function selectAllTaskIDs():void {
		var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.SELECT_ALL_TEST_TASK_IDS_SQL, {testID: test.id});
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private var taskIDsToUpdate:Array = [];
	private function executeComplete(result:SQLResult):void {
		for each(var obj:Object in result.data)
			if (obj.id)
				taskIDsToUpdate.push(obj.id);

		updateNextTask();
	}

	private var curTaskID:uint;
	private function updateNextTask(result:SQLResult = null):void {
		if (taskIDsToUpdate.length > 0) {
			curTaskID = taskIDsToUpdate.pop();
			updateTask(curTaskID);
		}
		else {
			dispatchSuccess()
		}
	}

	private function updateTask(id:uint):void {
		var sqlParams:Object = {};
		sqlParams.taskID = id;
		sqlParams.rate = test.calcTaskRate();
		sqlParams.complexity = TestTaskPriority.HIGH;
		sqlParams.isFailed = 0;
		sqlParams.lastTestedDate = 0;

		var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.UPDATE_TEST_TASK_SQL, sqlParams);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(updateNextTask, executeError));
	}

	override public function destroy():void {
		super.destroy();
		storage = null;
		test = null;
	}
}
}