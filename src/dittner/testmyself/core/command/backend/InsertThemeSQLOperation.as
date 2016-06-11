package dittner.testmyself.core.command.backend {

import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncCommand;

import dittner.satelliteFlight.command.CommandException;
import dittner.testmyself.core.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.core.command.backend.utils.SQLUtils;
import dittner.testmyself.core.model.theme.Theme;
import dittner.testmyself.core.service.NoteService;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;

public class InsertThemeSQLOperation extends AsyncOperation implements IAsyncCommand {

	public function InsertThemeSQLOperation(service:NoteService, theme:Theme) {
		super();
		this.service = service;
		this.theme = theme;
	}

	private var service:NoteService;
	private var theme:Theme;

	public function execute():void {
		if (theme) {
			var sql:String = service.sqlFactory.insertTheme;
			var sqlParams:Object = {};
			sqlParams.name = theme.name;

			var statement:SQLStatement = SQLUtils.createSQLStatement(sql, sqlParams);
			statement.sqlConnection = service.sqlConnection;
			statement.execute(-1, new Responder(executeComplete, executeError));
		}
		else {
			dispatchError(new CommandException(ErrorCode.NULLABLE_THEME, "Отсутствует добавляемая тема"));
		}
	}

	private function executeError(error:SQLError):void {
		dispatchError(new CommandException(ErrorCode.SQL_TRANSACTION_FAILED, error.details));
	}

	private function executeComplete(result:SQLResult):void {
		if (result.rowsAffected > 0) {
			theme.id = result.lastInsertRowID;
			dispatchSuccess();
		}
		else dispatchError(new CommandException(ErrorCode.THEME_ADDED_WITHOUT_ID, "База данных не вернула ID добавленной темы"));
	}

}
}