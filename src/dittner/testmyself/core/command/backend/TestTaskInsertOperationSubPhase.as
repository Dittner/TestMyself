package dittner.testmyself.core.command.backend {

import com.probertson.data.QueuedStatement;
import com.probertson.data.SQLRunner;

import dittner.satelliteFlight.command.CommandException;
import dittner.testmyself.core.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.core.command.backend.phaseOperation.PhaseOperation;
import dittner.testmyself.core.model.note.INote;
import dittner.testmyself.core.model.test.TestInfo;
import dittner.testmyself.core.model.test.TestModel;
import dittner.testmyself.core.model.test.TestTask;
import dittner.testmyself.core.model.test.TestTaskComplexity;

import flash.data.SQLResult;
import flash.errors.SQLError;

public class TestTaskInsertOperationSubPhase extends PhaseOperation {
	public function TestTaskInsertOperationSubPhase(note:INote, testInfo:TestInfo, sqlRunner:SQLRunner, sqlStatement:String, testModel:TestModel) {
		this.note = note;
		this.testInfo = testInfo;
		this.sqlRunner = sqlRunner;
		this.sqlStatement = sqlStatement;
		this.testModel = testModel;
	}

	private var note:INote;
	private var testInfo:TestInfo;
	private var sqlRunner:SQLRunner;
	private var sqlStatement:String;
	private var testModel:TestModel;

	override public function execute():void {
		if (note.id == -1) throw new CommandException(ErrorCode.NOTE_OF_TEST_TASK_HAS_NO_ID, "Нет ID записи, необходимого для сохранения тестовой задачи");
		if (!testModel.validate(note, testInfo)) {
			dispatchComplete();
			return;
		}

		var statements:Vector.<QueuedStatement> = new Vector.<QueuedStatement>();
		var sqlParams:Object = {};
		sqlParams.testID = testInfo.id;
		sqlParams.noteID = note.id;
		sqlParams.correct = 0;
		sqlParams.incorrect = 0;
		sqlParams.rate = testModel.calcTaskRate(new TestTask());
		sqlParams.complexity = TestTaskComplexity.HIGH;
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
		testInfo = null;
		sqlRunner = null;
		sqlStatement = null;
	}
}
}