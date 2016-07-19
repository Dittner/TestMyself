package de.dittner.testmyself.backend.op {

import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLUtils;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.note.SQLLib;

import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;

public class InsertExampleOperationSubPhase extends AsyncOperation implements IAsyncCommand {
	public function InsertExampleOperationSubPhase(conn:SQLConnection, example:Note) {
		this.example = example;
		this.conn = conn;
	}

	private var example:Note;
	private var conn:SQLConnection;

	public function execute():void {
		if (example.parentID == -1) {
			dispatchError(ErrorCode.PARENT_EXAMPLE_HAS_NO_ID + ": Нет ID записи, необходимого для сохранения примера");
			return;
		}

		var sqlParams:Object = example.serialize();
		var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.INSERT_NOTE_SQL, sqlParams);
		statement.sqlConnection = conn;
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private function executeComplete(result:SQLResult):void {
		if (result.rowsAffected > 0) {
			example.id = result.lastInsertRowID;
			dispatchSuccess();
		}
		else dispatchError(ErrorCode.THEME_ADDED_WITHOUT_ID + ": База данных не вернула ID добавленного примера");
	}

	private function executeError(error:SQLError):void {
		dispatchError(ErrorCode.SQL_TRANSACTION_FAILED + ": " + error.details);
	}

	override public function destroy():void {
		super.destroy();
		example = null;
		conn = null;
	}
}
}