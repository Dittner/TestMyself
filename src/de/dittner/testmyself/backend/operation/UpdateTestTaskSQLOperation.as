package de.dittner.testmyself.backend.operation {

import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.backend.SQLUtils;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.model.domain.test.Test;
import de.dittner.testmyself.model.domain.test.TestTask;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;

public class UpdateTestTaskSQLOperation extends AsyncOperation implements IAsyncCommand {

	public function UpdateTestTaskSQLOperation(service:SQLStorage, task:TestTask, testModel:TestModel) {
		this.service = service;
		this.task = task;
		this.testModel = testModel;
	}

	private var service:SQLStorage;
	private var task:TestTask;
	private var testModel:TestModel;

	public function execute():void {
		if (task && task.testID != -1 && task.noteID != -1) {
			var sqlParams:Object = {};
			sqlParams.testID = task.testID;
			sqlParams.noteID = task.noteID;
			sqlParams.complexity = task.complexity;
			sqlParams.isFailed = task.isFailed ? 1 : 0;
			sqlParams.lastTestedDate = task.lastTestedDate;
			sqlParams.rate = testModel.calcTaskRate();
			sqlParams.updatingTestID = task.testID;
			sqlParams.updatingNoteID = task.noteID;

			var testInfo:Test = testModel.testSpec.info;
			var sql:String = testInfo.useExamples ? service.sqlFactory.updateTestExampleTask : service.sqlFactory.updateTestTask;

			var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
			statement.sqlConnection = service.sqlConnection;
			statement.execute(-1, new Responder(executeComplete, executeError));
		}
		else {
			dispatchError(new CommandException(ErrorCode.EMPTY_THEME_NAME, "Отсутствует тестовая задача, которую требуется обновить в БД."));
		}
	}

	private function executeComplete(result:SQLResult):void {
		dispatchSuccess();
	}

	private function executeError(error:SQLError):void {
		dispatchError(new CommandException(ErrorCode.SQL_TRANSACTION_FAILED, error.details));
	}

}
}