package dittner.testmyself.core.command.backend {

import dittner.async.AsyncOperation;
import dittner.async.IAsyncCommand;
import dittner.satelliteFlight.command.CommandException;
import dittner.testmyself.core.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.core.command.backend.utils.SQLUtils;
import dittner.testmyself.core.model.note.Note;
import dittner.testmyself.core.model.note.SQLFactory;

import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;

public class NoteUpdateOperationPhase extends AsyncOperation implements IAsyncCommand {

	public function NoteUpdateOperationPhase(conn:SQLConnection, note:Note, sqlFactory:SQLFactory) {
		this.conn = conn;
		this.note = note;
		this.sqlFactory = sqlFactory;
	}

	private var note:Note;
	private var sqlFactory:SQLFactory;
	private var conn:SQLConnection;

	public function execute():void {
		var sqlParams:Object = note.toSQLData();
		sqlParams.updatingNoteID = note.id;

		var statement:SQLStatement = SQLUtils.createSQLStatement(sqlFactory.updateNote, sqlParams);
		statement.sqlConnection = conn;
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private function executeComplete(result:SQLResult):void {
		dispatchSuccess();
	}

	private function executeError(error:SQLError):void {
		dispatchError(new CommandException(ErrorCode.SQL_TRANSACTION_FAILED, error.details));
	}

	override public function destroy():void {
		super.destroy();
		note = null;
		conn = null;
	}
}
}
