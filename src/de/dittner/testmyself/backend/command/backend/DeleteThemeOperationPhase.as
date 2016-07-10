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

public class DeleteThemeOperationPhase extends AsyncOperation implements IAsyncCommand {

	public function DeleteThemeOperationPhase(conn:SQLConnection, themeID:int, sqlFactory:SQLFactory) {
		super();
		this.conn = conn;
		this.themeID = themeID;
		this.sqlFactory = sqlFactory;
	}

	private var conn:SQLConnection;
	private var themeID:int;
	private var sqlFactory:SQLFactory;

	public function execute():void {
		if (themeID == -1) {
			dispatchError(new CommandException(ErrorCode.NULLABLE_NOTE, "Отсутствует ID темы"));
		}
		else {
			var statement:SQLStatement = SQLUtils.createSQLStatement(sqlFactory.deleteTheme, {deletingThemeID: themeID});
			statement.sqlConnection = conn;
			statement.execute(-1, new Responder(deleteCompleteHandler, deleteFailedHandler));
		}
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