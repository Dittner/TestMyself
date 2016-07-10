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

public class UpdateFilterOperationPhase extends AsyncOperation implements IAsyncCommand {

	public function UpdateFilterOperationPhase(conn:SQLConnection, newThemeID:int, oldThemeID:int, sqlFactory:SQLFactory) {
		super();
		this.conn = conn;
		this.newThemeID = newThemeID;
		this.oldThemeID = oldThemeID;
		this.sqlFactory = sqlFactory;
	}

	private var conn:SQLConnection;
	private var newThemeID:int;
	private var oldThemeID:int;
	private var sqlFactory:SQLFactory;

	public function execute():void {
		if (newThemeID != -1 && oldThemeID != -1) {
			var sqlParams:Object = {};
			sqlParams.newThemeID = newThemeID;
			sqlParams.oldThemeID = oldThemeID;

			var statement:SQLStatement = SQLUtils.createSQLStatement(sqlFactory.updateFilter, sqlParams);
			statement.sqlConnection = conn;
			statement.execute(-1, new Responder(executeComplete, executeError));
		}
		else dispatchError(new CommandException(ErrorCode.NULLABLE_NOTE, "Отсутствует ID темы"));
	}

	private function executeComplete(result:SQLResult):void {
		dispatchSuccess();
	}

	private function executeError(error:SQLError):void {
		dispatchError(new CommandException(ErrorCode.SQL_TRANSACTION_FAILED, error.details));
	}

	override public function destroy():void {
		super.destroy();
		conn = null;
	}
}
}