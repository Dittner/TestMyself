package de.dittner.testmyself.backend.op {

import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.testmyself.backend.SQLUtils;
import de.dittner.testmyself.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogCategory;
import de.dittner.testmyself.model.domain.note.SQLLib;

import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;

public class DeleteTestTaskByNoteIDOperationPhase extends AsyncOperation implements IAsyncCommand {

	public function DeleteTestTaskByNoteIDOperationPhase(conn:SQLConnection, noteID:int) {
		super();
		this.conn = conn;
		this.noteID = noteID;
	}

	private var conn:SQLConnection;
	private var noteID:int;

	public function execute():void {
		if (noteID != -1) {
			var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.DELETE_TEST_TASK_BY_NOTE_ID_SQL, {deletingNoteID: noteID});
			statement.sqlConnection = conn;
			statement.execute(-1, new Responder(deleteNoteTestTasksCompleteHandler, deleteFailedHandler));
		}
		else {
			CLog.err(LogCategory.STORAGE, ErrorCode.NULLABLE_NOTE + ": Отсутствует ID записи");
			dispatchError(ErrorCode.NULLABLE_NOTE);
		}
	}

	private function deleteNoteTestTasksCompleteHandler(result:SQLResult):void {
		var statement:SQLStatement = SQLUtils.createSQLStatement(SQLLib.DELETE_TEST_TASK_BY_PARENT_ID_SQL, {parentID: noteID});
		statement.sqlConnection = conn;
		statement.execute(-1, new Responder(deleteExamplesTestTasksCompleteHandler, deleteFailedHandler));
	}

	private function deleteExamplesTestTasksCompleteHandler(result:SQLResult):void {
		dispatchSuccess();
	}

	private function deleteFailedHandler(error:SQLError):void {
		CLog.err(LogCategory.STORAGE, ErrorCode.SQL_TRANSACTION_FAILED + ": " + error.details);
		dispatchError(ErrorCode.SQL_TRANSACTION_FAILED);
	}

	override public function destroy():void {
		super.destroy();
		conn = null;
	}
}
}