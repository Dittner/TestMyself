package de.dittner.testmyself.backend.op {

import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogCategory;
import de.dittner.testmyself.model.domain.test.Test;
import de.dittner.testmyself.model.domain.test.TestTaskComplexity;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;
import flash.utils.getQualifiedClassName;

public class ClearTestHistoryOperationPhase extends AsyncOperation implements IAsyncCommand {
	public function ClearTestHistoryOperationPhase(testID:int, noteID:int, storage:Storage, test:Test) {
		this.testID = testID;
		this.noteID = noteID;
		this.storage = storage;
		this.test = test;
	}

	private var testID:int;
	private var noteID:int;
	private var storage:Storage;
	private var test:Test;

	public function execute():void {
		if (noteID == -1) {
			CLog.err(LogCategory.STORAGE, getQualifiedClassName(this) + " " + ErrorCode.NOTE_OF_TEST_TASK_HAS_NO_ID + ": Нет ID записи, необходимого для удаления результатов теста");
			dispatchError(ErrorCode.NOTE_OF_TEST_TASK_HAS_NO_ID);
			return;
		}

		var sqlParams:Object = {};
		sqlParams.testID = testID;
		sqlParams.noteID = noteID;
		sqlParams.rate = test.calcTaskRate();
		sqlParams.complexity = TestTaskComplexity.HIGH;
		sqlParams.isFailed = 0;
		sqlParams.lastTestedDate = 0;
		sqlParams.updatingTestID = testID;
		sqlParams.updatingNoteID = noteID;

		var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.UPDATE_TEST_TASK_SQL, sqlParams);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private function executeComplete(result:SQLResult):void {
		dispatchSuccess();
	}

	private function executeError(error:SQLError):void {
		CLog.err(LogCategory.STORAGE, getQualifiedClassName(this) + " " + ErrorCode.SQL_TRANSACTION_FAILED + ": " + error.details);
		dispatchError(ErrorCode.SQL_TRANSACTION_FAILED);
	}

	override public function destroy():void {
		super.destroy();
		storage = null;
		test = null;
	}
}
}