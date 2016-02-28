package dittner.testmyself.core.command.backend {

import dittner.async.AsyncOperation;
import dittner.async.IAsyncCommand;
import dittner.satelliteFlight.command.CommandException;
import dittner.testmyself.core.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.core.command.backend.utils.SQLUtils;
import dittner.testmyself.core.model.theme.Theme;
import dittner.testmyself.core.service.NoteService;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.errors.SQLError;
import flash.net.Responder;

public class UpdateThemeSQLOperation extends AsyncOperation implements IAsyncCommand {

	public function UpdateThemeSQLOperation(service:NoteService, theme:Theme) {
		this.service = service;
		this.theme = theme;
	}

	private var service:NoteService;
	private var theme:Theme;

	public function execute():void {
		if (theme && theme.id != -1 && theme.name) {
			var sqlParams:Object = {};
			sqlParams.themeID = theme.id;
			sqlParams.name = theme.name;

			var statement:SQLStatement = SQLUtils.createSQLStatement(service.sqlFactory.updateTheme, sqlParams);
			statement.sqlConnection = service.sqlConnection;
			statement.execute(-1, new Responder(executeComplete, executeError));
		}
		else {
			dispatchError(new CommandException(ErrorCode.EMPTY_THEME_NAME, "Отсутствует имя у созданной темы"));
		}
	}

	private function executeComplete(result:SQLResult):void {
		dispatchSuccess();
	}

	private function executeError(error:SQLError):void {
		dispatchError(new CommandException(ErrorCode.SQL_TRANSACTION_FAILED, error.details));
	}

}
}