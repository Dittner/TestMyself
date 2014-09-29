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

public class UpdateThemeSQLOperation extends DeferredOperation {

	public function UpdateThemeSQLOperation(service:NoteService, theme:Theme) {
		this.service = service;
		this.theme = theme;
	}

	private var service:NoteService;
	private var theme:Theme;

	override public function process():void {
		if (theme && theme.id != -1 && theme.name) {
			var sqlParams:Object = {};
			sqlParams.themeID = theme.id;
			sqlParams.name = theme.name;

			service.sqlRunner.executeModify(Vector.<QueuedStatement>([new QueuedStatement(service.sqlFactory.updateTheme, sqlParams)]), executeComplete, executeError);
		}
		else {
			dispatchCompleteWithError(new CommandException(ErrorCode.EMPTY_THEME_NAME, "Отсутствует имя у созданной темы"));
		}
	}

	private function executeComplete(results:Vector.<SQLResult>):void {
		dispatchCompleteSuccess(CommandResult.OK);
	}

	private function executeError(error:SQLError):void {
		dispatchCompleteWithError(new CommandException(ErrorCode.SQL_TRANSACTION_FAILED, error.details));
	}

}
}