package de.dittner.testmyself.backend.op {

import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogCategory;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.test.Test;
import de.dittner.testmyself.model.domain.test.TestTaskComplexity;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;
import flash.utils.getQualifiedClassName;

public class InsertTestTaskOperationPhase extends AsyncOperation implements IAsyncCommand {
	public function InsertTestTaskOperationPhase(storage:Storage, note:Note, test:Test) {
		this.note = note;
		this.storage = storage;
		this.test = test;
	}

	private var note:Note;
	private var storage:Storage;
	private var test:Test;

	public function execute():void {
		if (!note || note.id == -1) {
			CLog.err(LogCategory.STORAGE, getQualifiedClassName(this) + " " + ErrorCode.NOTE_OF_TEST_TASK_HAS_NO_ID + ": Нет ID записи, необходимого для сохранения тестовой задачи");
			dispatchError(ErrorCode.NOTE_OF_TEST_TASK_HAS_NO_ID);
			return;
		}

		var sqlParams:Object = {};
		sqlParams.testID = test.id;
		sqlParams.noteID = note.id;
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

	private function executeError(error:SQLError):void {
		CLog.err(LogCategory.STORAGE, getQualifiedClassName(this) + " " + ErrorCode.SQL_TRANSACTION_FAILED + ": " + error.details);
		dispatchError(ErrorCode.SQL_TRANSACTION_FAILED);
	}

	override public function destroy():void {
		super.destroy();
		note = null;
		test = null;
		storage = null;
	}
}
}