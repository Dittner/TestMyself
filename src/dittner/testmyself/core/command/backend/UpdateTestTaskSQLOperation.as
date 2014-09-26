package dittner.testmyself.core.command.backend {
import com.probertson.data.QueuedStatement;

import dittner.satelliteFlight.command.CommandException;
import dittner.satelliteFlight.command.CommandResult;
import dittner.testmyself.core.command.backend.deferredOperation.DeferredOperation;
import dittner.testmyself.core.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.core.model.test.TestModel;
import dittner.testmyself.core.model.test.TestTask;
import dittner.testmyself.core.service.NoteService;

import flash.data.SQLResult;
import flash.errors.SQLError;

public class UpdateTestTaskSQLOperation extends DeferredOperation {

	public function UpdateTestTaskSQLOperation(service:NoteService, task:TestTask, testModel:TestModel) {
		this.service = service;
		this.task = task;
		this.testModel = testModel;
	}

	private var service:NoteService;
	private var task:TestTask;
	private var testModel:TestModel;

	override public function process():void {
		if (task && task.testID != -1 && task.noteID != -1) {
			var sqlParams:Object = {};
			sqlParams.testID = task.testID;
			sqlParams.noteID = task.noteID;
			sqlParams.balance = task.balance;
			sqlParams.balanceIndex = testModel.calcBalanceIndex(task.balance, task.amount);
			sqlParams.amount = task.amount;
			sqlParams.amountIndex = testModel.calcAmountIndex(task.balance, task.amount);
			sqlParams.updatingTestID = task.testID;
			sqlParams.updatingNoteID = task.noteID;

			service.sqlRunner.executeModify(Vector.<QueuedStatement>([new QueuedStatement(service.sqlFactory.updateTestTask, sqlParams)]), executeComplete, executeError);
		}
		else {
			dispatchCompleteWithError(new CommandException(ErrorCode.EMPTY_THEME_NAME, "Отсутствует тестовая задача, которую требуется обновить в БД."));
		}
	}

	private function executeComplete(results:Vector.<SQLResult>):void {
		dispatchCompleteSuccess(CommandResult.OK);
	}

	private function executeError(error:SQLError):void {
		dispatchCompleteWithError(new CommandException(ErrorCode.SQL_TRANSACTION_FAILED, error.details));
	}

}
}