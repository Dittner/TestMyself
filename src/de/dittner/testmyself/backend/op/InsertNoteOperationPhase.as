package de.dittner.testmyself.backend.op {

import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLUtils;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogCategory;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.note.SQLLib;

import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;

public class InsertNoteOperationPhase extends AsyncOperation implements IAsyncCommand {

	public function InsertNoteOperationPhase(conn:SQLConnection, note:Note) {
		this.conn = conn;
		this.note = note;
	}

	private var conn:SQLConnection;
	private var note:Note;

	public function execute():void {
		var sqlParams:Object = note.serialize();
		var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.INSERT_NOTE_SQL, sqlParams);
		statement.sqlConnection = conn;
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private function executeComplete(result:SQLResult):void {
		if (result.rowsAffected > 0) {
			note.id = result.lastInsertRowID;
			dispatchSuccess();
		}
		else {
			CLog.err(LogCategory.STORAGE, ErrorCode.NOTE_ADDED_WITHOUT_ID + ": База данных не вернула ID после добавления записи");
			dispatchError(ErrorCode.NOTE_ADDED_WITHOUT_ID);
		}
	}

	private function executeError(error:SQLError):void {
		CLog.err(LogCategory.STORAGE, ErrorCode.SQL_TRANSACTION_FAILED + ": " + error.details);
		dispatchError(ErrorCode.SQL_TRANSACTION_FAILED);
	}

	override public function destroy():void {
		super.destroy();
		note = null;
		conn = null;
	}
}
}
