package de.dittner.testmyself.backend.command.backend {

import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;
import de.dittner.satelliteFlight.command.CommandException;
import de.dittner.testmyself.backend.command.backend.deferredOperation.ErrorCode;
import de.dittner.testmyself.backend.command.backend.utils.SQLUtils;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.note.SQLFactory;

import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;

public class NoteInsertOperationPhase extends AsyncOperation implements IAsyncCommand {

	public function NoteInsertOperationPhase(conn:SQLConnection, note:Note, sqlFactory:SQLFactory) {
		this.conn = conn;
		this.note = note;
		this.sqlFactory = sqlFactory;
	}

	private var conn:SQLConnection;
	private var note:Note;
	private var sqlFactory:SQLFactory;

	public function execute():void {
		var sqlParams:Object = note.toSQLData();
		var statement:SQLStatement = SQLUtils.createSQLStatement(sqlFactory.insertNote, sqlParams);
		statement.sqlConnection = conn;
		statement.execute(-1, new Responder(executeComplete, executeError));
	}

	private function executeComplete(result:SQLResult):void {
		if (result.rowsAffected > 0) {
			note.id = result.lastInsertRowID;
			dispatchSuccess();
		}
		else {
			dispatchError(new CommandException(ErrorCode.NOTE_ADDED_WITHOUT_ID, "База данных не вернула ID после добавления записи"));
		}
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
