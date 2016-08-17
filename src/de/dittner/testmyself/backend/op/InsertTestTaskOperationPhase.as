package de.dittner.testmyself.backend.op {

import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.model.domain.test.Test;
import de.dittner.testmyself.model.domain.test.TestTaskComplexity;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.net.Responder;

public class InsertTestTaskOperationPhase extends StorageOperation implements IAsyncCommand {
	public function InsertTestTaskOperationPhase(storage:Storage, noteID:int, test:Test) {
		this.noteID = noteID;
		this.storage = storage;
		this.test = test;
	}

	private var noteID:int;
	private var storage:Storage;
	private var test:Test;

	public function execute():void {
		if (noteID == -1) {
			dispatchError(ErrorCode.NOTE_OF_TEST_TASK_HAS_NO_ID + ": Нет ID записи, необходимого для сохранения тестовой задачи");
			return;
		}

		var sqlParams:Object = {};
		sqlParams.testID = test.id;
		sqlParams.noteID = noteID;
		sqlParams.isFailed = 0;
		sqlParams.lastTestedDate = 0;
		sqlParams.rate = test.calcTaskRate();
		sqlParams.complexity = TestTaskComplexity.HIGH;

		var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.INSERT_TEST_TASK_SQL, sqlParams);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private function executeComplete(result:SQLResult):void {
		dispatchSuccess();
	}

	override public function destroy():void {
		super.destroy();
		test = null;
		storage = null;
	}
}
}