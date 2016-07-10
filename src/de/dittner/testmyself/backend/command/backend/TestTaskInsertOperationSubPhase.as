package de.dittner.testmyself.backend.command.backend {

import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.satelliteFlight.command.CommandException;
import de.dittner.testmyself.backend.command.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.backend.command.backend.utils.SQLUtils;
import de.dittner.testmyself.model.domain.note.INote;
import de.dittner.testmyself.model.domain.test.TestInfo;
import de.dittner.testmyself.model.domain.test.TestModel;
import de.dittner.testmyself.model.domain.test.TestTaskComplexity;

import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;

public class TestTaskInsertOperationSubPhase extends AsyncOperation implements IAsyncCommand {
	public function TestTaskInsertOperationSubPhase(note:INote, testInfo:TestInfo, conn:SQLConnection, sql:String, testModel:TestModel) {
		this.note = note;
		this.testInfo = testInfo;
		this.conn = conn;
		this.sql = sql;
		this.testModel = testModel;
	}

	private var note:INote;
	private var testInfo:TestInfo;
	private var conn:SQLConnection;
	private var sql:String;
	private var testModel:TestModel;

	public function execute():void {
		if (note.id == -1) {
			dispatchError(new CommandException(ErrorCode.NOTE_OF_TEST_TASK_HAS_NO_ID, "Нет ID записи, необходимого для сохранения тестовой задачи"));
			return;
		}
		if (!testModel.validate(note, testInfo)) {
			dispatchSuccess();
			return;
		}

		var sqlParams:Object = {};
		sqlParams.testID = testInfo.id;
		sqlParams.noteID = note.id;
		sqlParams.isFailed = 0;
		sqlParams.lastTestedDate = 0;
		sqlParams.rate = testModel.calcTaskRate();
		sqlParams.complexity = TestTaskComplexity.HIGH;

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
		testInfo = null;
		conn = null;
		sql = null;
	}
}
}