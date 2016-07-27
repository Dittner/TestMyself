package de.dittner.testmyself.backend.op {

import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLLib;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogCategory;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;
import flash.utils.getQualifiedClassName;

public class DeleteTestTaskByNoteIDOperation extends AsyncOperation implements IAsyncCommand {

	public function DeleteTestTaskByNoteIDOperation(storage:Storage, noteID:int) {
		super();
		this.storage = storage;
		this.noteID = noteID;
	}

	private var storage:Storage;
	private var noteID:int;

	public function execute():void {
		if (noteID != -1) {
			var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.DELETE_TEST_TASK_BY_NOTE_ID_SQL, {deletingNoteID: noteID});
			statement.sqlConnection = storage.sqlConnection;
			statement.execute(-1, new Responder(deleteNoteTestTasksCompleteHandler, deleteFailedHandler));
		}
		else {
			CLog.err(LogCategory.STORAGE, getQualifiedClassName(this) + " " + ErrorCode.NULLABLE_NOTE + ": Отсутствует ID записи");
			dispatchError(ErrorCode.NULLABLE_NOTE);
		}
	}

	private function deleteNoteTestTasksCompleteHandler(result:SQLResult):void {
		var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.DELETE_TEST_TASK_BY_PARENT_ID_SQL, {parentID: noteID});
		statement.sqlConnection = storage.sqlConnection;
		statement.execute(-1, new Responder(deleteExamplesTestTasksCompleteHandler, deleteFailedHandler));
	}

	private function deleteExamplesTestTasksCompleteHandler(result:SQLResult):void {
		dispatchSuccess();
	}

	private function deleteFailedHandler(error:SQLError):void {
		CLog.err(LogCategory.STORAGE, getQualifiedClassName(this) + " " + ErrorCode.SQL_TRANSACTION_FAILED + ": " + error.details);
		dispatchError(ErrorCode.SQL_TRANSACTION_FAILED);
	}

	override public function destroy():void {
		super.destroy();
		storage = null;
	}
}
}