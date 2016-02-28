package dittner.testmyself.core.command.backend {

import dittner.async.AsyncOperation;
import dittner.async.IAsyncCommand;
import dittner.satelliteFlight.command.CommandException;
import dittner.testmyself.core.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.core.command.backend.utils.SQLUtils;
import dittner.testmyself.core.model.test.TestModel;
import dittner.testmyself.core.model.test.TestTaskComplexity;

import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;

public class ClearTestHistoryOperationSubPhase extends AsyncOperation implements IAsyncCommand {
	public function ClearTestHistoryOperationSubPhase(testID:int, noteID:int, conn:SQLConnection, sql:String, testModel:TestModel) {
		this.testID = testID;
		this.noteID = noteID;
		this.conn = conn;
		this.sql = sql;
		this.testModel = testModel;
	}

	private var testID:int;
	private var noteID:int;
	private var conn:SQLConnection;
	private var sql:String;
	private var testModel:TestModel;

	public function execute():void {
		if (noteID == -1) {
			dispatchError(new CommandException(ErrorCode.NOTE_OF_TEST_TASK_HAS_NO_ID, "Нет ID записи, необходимого для удаления результатов теста"));
			return;
		}

		var sqlParams:Object = {};
		sqlParams.testID = testID;
		sqlParams.noteID = noteID;
		sqlParams.rate = testModel.calcTaskRate();
		sqlParams.complexity = TestTaskComplexity.HIGH;
		sqlParams.isFailed = 0;
		sqlParams.lastTestedDate = 0;
		sqlParams.updatingTestID = testID;
		sqlParams.updatingNoteID = noteID;

		var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
		statement.sqlConnection = conn;
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private function executeComplete(result:SQLResult):void {
		dispatchSuccess();
	}

	private function executeError(error:SQLError):void {
		dispatchError(new CommandException(ErrorCode.SQL_TRANSACTION_FAILED, error.details));
	}

	override public function destroy():void {
		super.destroy();
		conn = null;
		sql = null;
		testModel = null;
	}
}
}