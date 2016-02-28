package dittner.testmyself.core.command.backend {

import dittner.async.AsyncOperation;
import dittner.async.IAsyncCommand;
import dittner.satelliteFlight.command.CommandException;
import dittner.testmyself.core.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.core.command.backend.utils.SQLUtils;
import dittner.testmyself.core.model.note.SQLFactory;

import flash.data.SQLConnection;
import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;

public class DeleteNotesByThemeOperationPhase extends AsyncOperation implements IAsyncCommand {

	public function DeleteNotesByThemeOperationPhase(conn:SQLConnection, themeID:int, sqlFactory:SQLFactory) {
		super();
		this.conn = conn;
		this.themeID = themeID;
		this.sqlFactory = sqlFactory;
	}

	private var conn:SQLConnection;
	private var themeID:int;
	private var sqlFactory:SQLFactory;

	public function execute():void {
		if (themeID != -1) {
			var statement:SQLStatement = SQLUtils.createSQLStatement(sqlFactory.deleteNotesByTheme, {deletingThemeID: themeID});
			statement.sqlConnection = conn;
			statement.execute(-1, new Responder(deleteCompleteHandler, deleteFailedHandler));
		}
		else dispatchError(new CommandException(ErrorCode.NULLABLE_NOTE, "Отсутствует тема в БД с id = -1"));
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