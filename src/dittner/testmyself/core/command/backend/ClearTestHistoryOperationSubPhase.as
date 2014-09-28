package dittner.testmyself.core.command.backend {

import com.probertson.data.QueuedStatement;
import com.probertson.data.SQLRunner;

import dittner.satelliteFlight.command.CommandException;
import dittner.testmyself.core.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.core.command.backend.phaseOperation.PhaseOperation;
import dittner.testmyself.core.model.test.TestModel;

import flash.data.SQLResult;
import flash.errors.SQLError;

public class ClearTestHistoryOperationSubPhase extends PhaseOperation {
	public function ClearTestHistoryOperationSubPhase(testID:int, noteID:int, sqlRunner:SQLRunner, sqlStatement:String, testModel:TestModel) {
		this.testID = testID;
		this.noteID = noteID;
		this.sqlRunner = sqlRunner;
		this.sqlStatement = sqlStatement;
		this.testModel = testModel;
	}

	private var testID:int;
	private var noteID:int;
	private var sqlRunner:SQLRunner;
	private var sqlStatement:String;
	private var testModel:TestModel;

	override public function execute():void {
		if (noteID == -1) throw new CommandException(ErrorCode.NOTE_OF_TEST_TASK_HAS_NO_ID, "Нет ID записи, необходимого для удаления результатов теста");

		var statements:Vector.<QueuedStatement> = new Vector.<QueuedStatement>();
		var sqlParams:Object = {};
		sqlParams.testID = testID;
		sqlParams.noteID = noteID;
		sqlParams.balance = 0;
		sqlParams.balanceIndex = testModel.calcBalanceIndex(0, 0);
		sqlParams.amount = 0;
		sqlParams.amountIndex = testModel.calcAmountIndex(0, 0);
		sqlParams.updatingTestID = testID;
		sqlParams.updatingNoteID = noteID;

		statements.push(new QueuedStatement(sqlStatement, sqlParams));
		sqlRunner.executeModify(statements, executeComplete, executeError);
	}

	private function executeComplete(results:Vector.<SQLResult>):void {
		dispatchComplete();
	}

	private function executeError(error:SQLError):void {
		throw new CommandException(ErrorCode.SQL_TRANSACTION_FAILED, error.details);
	}

	override public function destroy():void {
		super.destroy();
		sqlRunner = null;
		sqlStatement = null;
		testModel = null;
	}
}
}