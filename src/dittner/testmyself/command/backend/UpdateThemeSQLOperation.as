package dittner.testmyself.command.backend {
import com.probertson.data.QueuedStatement;
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.backend.deferredOperation.DeferredOperation;
import dittner.testmyself.command.backend.deferredOperation.ErrorCode;
import dittner.testmyself.command.backend.result.CommandException;
import dittner.testmyself.command.backend.result.CommandResult;
import dittner.testmyself.command.backend.utils.SQLFactory;
import dittner.testmyself.model.theme.Theme;

import flash.data.SQLResult;
import flash.errors.SQLError;

public class UpdateThemeSQLOperation extends DeferredOperation {

	public function UpdateThemeSQLOperation(sqlRunner:SQLRunner, theme:Theme, sqlFactory:SQLFactory) {
		this.sqlRunner = sqlRunner;
		this.theme = theme;
		this.sqlFactory = sqlFactory;
	}

	private var sqlRunner:SQLRunner;
	private var theme:Theme;
	private var sqlFactory:SQLFactory;

	override public function process():void {
		if (theme && theme.id && theme.name) {
			var sqlParams:Object = {};
			sqlParams.themeID = theme.id;
			sqlParams.name = theme.name;

			sqlRunner.executeModify(Vector.<QueuedStatement>([new QueuedStatement(sqlFactory.updateTheme, sqlParams)]), executeComplete, executeError);
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