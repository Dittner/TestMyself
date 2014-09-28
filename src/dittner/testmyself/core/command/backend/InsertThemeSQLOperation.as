package dittner.testmyself.core.command.backend {
import com.probertson.data.QueuedStatement;

import dittner.satelliteFlight.command.CommandException;
import dittner.satelliteFlight.command.CommandResult;
import dittner.testmyself.core.command.backend.deferredOperation.DeferredOperation;
import dittner.testmyself.core.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.core.model.theme.Theme;
import dittner.testmyself.core.service.NoteService;

import flash.data.SQLResult;
import flash.errors.SQLError;

public class InsertThemeSQLOperation extends DeferredOperation {

	public function InsertThemeSQLOperation(service:NoteService, theme:Theme) {
		super();
		this.service = service;
		this.theme = theme;
	}

	private var service:NoteService;
	private var theme:Theme;

	override public function process():void {
		if (theme) {
			var statements:Vector.<QueuedStatement> = new Vector.<QueuedStatement>();
			var sqlParams:Object = {};
			sqlParams.name = theme.name;
			statements.push(new QueuedStatement(service.sqlFactory.insertTheme, sqlParams));
			service.sqlRunner.executeModify(statements, executeComplete, executeError);
		}
		else {
			dispatchCompleteWithError(new CommandException(ErrorCode.NULLABLE_THEME, "Отсутствует добавляемая тема"));
		}
	}

	private function executeError(error:SQLError):void {
		dispatchCompleteWithError(new CommandException(ErrorCode.SQL_TRANSACTION_FAILED, error.details));
	}

	private function executeComplete(results:Vector.<SQLResult>):void {
		var result:SQLResult = results[0];
		if (result.rowsAffected > 0) {
			theme.id = result.lastInsertRowID;
			dispatchCompleteSuccess(CommandResult.OK);
		}
		else dispatchCompleteWithError(new CommandException(ErrorCode.THEME_ADDED_WITHOUT_ID, "База данных не вернула ID добавленной темы"));
	}

}
}