package de.dittner.testmyself.backend.command.backend {

import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.satelliteFlight.command.CommandException;
import de.dittner.testmyself.backend.command.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.backend.command.backend.utils.SQLUtils;
import de.dittner.testmyself.model.domain.note.SQLFactory;

import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;

public class DeleteFilterByNoteIDOperationPhase extends AsyncOperation implements IAsyncCommand {

	public function DeleteFilterByNoteIDOperationPhase(conn:SQLConnection, noteID:int, sqlFactory:SQLFactory) {
		super();
		this.conn = conn;
		this.noteID = noteID;
		this.sqlFactory = sqlFactory;
	}

	private var conn:SQLConnection;
	private var noteID:int;
	private var sqlFactory:SQLFactory;

	public function execute():void {
		if (noteID) {
			var statement:SQLStatement = SQLUtils.createSQLStatement(sqlFactory.deleteFilterByNoteID, {deletingNoteID: noteID});
			statement.sqlConnection = conn;
			statement.execute(-1, new Responder(deleteCompleteHandler, deleteFailedHandler));
		}
		else dispatchError(new CommandException(ErrorCode.NULLABLE_NOTE, "Отсутствует ID записи"));
	}

	private function deleteCompleteHandler(result:SQLResult):void {
		dispatchSuccess();
	}

	private function deleteFailedHandler(error:SQLError):void {
		dispatchError(new CommandException(ErrorCode.SQL_TRANSACTION_FAILED, error.details));
	}

	override public function destroy():void {
		super.destroy();
		conn = null;
	}
}
}