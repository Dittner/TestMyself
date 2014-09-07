package dittner.testmyself.core.command.backend {

import com.probertson.data.QueuedStatement;
import com.probertson.data.SQLRunner;

import dittner.satelliteFlight.command.CommandException;
import dittner.testmyself.core.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.core.command.backend.phaseOperation.PhaseOperation;
import dittner.testmyself.core.model.note.Note;

import flash.data.SQLResult;
import flash.errors.SQLError;

public class ExampleInsertOperationSubPhase extends PhaseOperation {
	public function ExampleInsertOperationSubPhase(noteID:int, example:Note, sqlRunner:SQLRunner, sqlStatement:String) {
		this.noteID = noteID;
		this.example = example;
		this.sqlRunner = sqlRunner;
		this.sqlStatement = sqlStatement;
	}

	private var noteID:int;
	private var example:Note;
	private var sqlRunner:SQLRunner;
	private var sqlStatement:String;

	override public function execute():void {
		var statements:Vector.<QueuedStatement> = new Vector.<QueuedStatement>();
		var sqlParams:Object = example.toSQLData();
		sqlParams.noteID = noteID;
		if (noteID == -1)
			throw new CommandException(ErrorCode.PARENT_EXAMPLE_HAS_NO_ID, "Нет ID записи, необходимого для сохранения примера");
		statements.push(new QueuedStatement(sqlStatement, sqlParams));
		sqlRunner.executeModify(statements, executeComplete, executeError);
	}

	private function executeComplete(results:Vector.<SQLResult>):void {
		var result:SQLResult = results[0];
		if (result.rowsAffected > 0) {
			example.id = result.lastInsertRowID;
			dispatchComplete();
		}
		else throw new CommandException(ErrorCode.THEME_ADDED_WITHOUT_ID, "База данных не вернула ID добавленного примера");
	}

	private function executeError(error:SQLError):void {
		throw new CommandException(ErrorCode.SQL_TRANSACTION_FAILED, error.details);
	}

	override public function destroy():void {
		super.destroy();
		example = null;
		sqlRunner = null;
		sqlStatement = null;
	}
}
}