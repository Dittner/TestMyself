package de.dittner.testmyself.backend.command.backend {

import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.satelliteFlight.command.CommandException;
import de.dittner.testmyself.backend.command.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.backend.command.backend.utils.SQLUtils;
import de.dittner.testmyself.model.domain.note.Note;

import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;

public class ExampleInsertOperationSubPhase extends AsyncOperation implements IAsyncCommand {
	public function ExampleInsertOperationSubPhase(noteID:int, example:Note, conn:SQLConnection, sql:String) {
		this.noteID = noteID;
		this.example = example;
		this.conn = conn;
		this.sql = sql;
	}

	private var noteID:int;
	private var example:Note;
	private var conn:SQLConnection;
	private var sql:String;

	public function execute():void {
		if (noteID == -1) {
			dispatchError(new CommandException(ErrorCode.PARENT_EXAMPLE_HAS_NO_ID, "Нет ID записи, необходимого для сохранения примера"));
			return;
		}

		var sqlParams:Object = example.toSQLData();
		sqlParams.noteID = noteID;
		var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
		statement.sqlConnection = conn;
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private function executeComplete(result:SQLResult):void {
		if (result.rowsAffected > 0) {
			example.id = result.lastInsertRowID;
			dispatchSuccess();
		}
		else dispatchError(new CommandException(ErrorCode.THEME_ADDED_WITHOUT_ID, "База данных не вернула ID добавленного примера"));
	}

	private function executeError(error:SQLError):void {
		dispatchError(new CommandException(ErrorCode.SQL_TRANSACTION_FAILED, error.details));
	}

	override public function destroy():void {
		super.destroy();
		example = null;
		conn = null;
		sql = null;
	}
}
}