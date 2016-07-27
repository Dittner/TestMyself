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

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;
import flash.utils.getQualifiedClassName;

public class InsertExampleOperationPhase extends AsyncOperation implements IAsyncCommand {
	public function InsertExampleOperationPhase(storage:Storage, example:Note) {
		this.example = example;
		this.storage = storage;
	}

	private var example:Note;
	private var storage:Storage;

	public function execute():void {
		if (example.parentID == -1) {
			CLog.err(LogCategory.STORAGE, getQualifiedClassName(this) + ": Нет ID записи, необходимого для сохранения примера");
			dispatchError(ErrorCode.PARENT_EXAMPLE_HAS_NO_ID);
			return;
		}

		var sqlParams:Object = example.serialize();
		var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.INSERT_NOTE_SQL, sqlParams);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private function executeComplete(result:SQLResult):void {
		if (result.rowsAffected > 0) {
			example.id = result.lastInsertRowID;
			dispatchSuccess();
		}
		else dispatchError(getQualifiedClassName(this) + " " + ErrorCode.THEME_ADDED_WITHOUT_ID + ": База данных не вернула ID добавленного примера");
	}

	private function executeError(error:SQLError):void {
		CLog.err(LogCategory.STORAGE, getQualifiedClassName(this) + " " + ErrorCode.SQL_TRANSACTION_FAILED + ": " + error.details);
		dispatchError(ErrorCode.SQL_TRANSACTION_FAILED);
	}

	override public function destroy():void {
		super.destroy();
		example = null;
		storage = null;
	}
}
}