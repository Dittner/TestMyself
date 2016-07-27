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

public class UpdateNoteOperation extends AsyncOperation implements IAsyncCommand {

	public function UpdateNoteOperation(storage:Storage, note:Note) {
		this.storage = storage;
		this.note = note;
	}

	private var note:Note;
	private var storage:Storage;

	public function execute():void {
		var sqlParams:Object = note.serialize();
		sqlParams.updatingNoteID = note.id;

		var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.UPDATE_NOTE_SQL, sqlParams);
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private function executeComplete(result:SQLResult):void {
		dispatchSuccess();
	}

	private function executeError(error:SQLError):void {
		CLog.err(LogCategory.STORAGE, getQualifiedClassName(this) + " " + ErrorCode.SQL_TRANSACTION_FAILED + ": " + error.details);
		dispatchError(ErrorCode.SQL_TRANSACTION_FAILED);
	}

	override public function destroy():void {
		super.destroy();
		note = null;
		storage = null;
	}
}
}
