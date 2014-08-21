package dittner.testmyself.command.backend.phrase {
import com.probertson.data.QueuedStatement;
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.operation.deferredOperation.DeferredOperation;
import dittner.testmyself.command.operation.deferredOperation.ErrorCode;
import dittner.testmyself.command.operation.result.CommandException;
import dittner.testmyself.command.operation.result.CommandResult;
import dittner.testmyself.model.theme.Theme;

import flash.data.SQLResult;
import flash.errors.SQLError;

public class UpdatePhraseThemeSQLOperation extends DeferredOperation {
	[Embed(source="/dittner/testmyself/command/backend/phrase/sql/UpdatePhraseTheme.sql", mimeType="application/octet-stream")]
	private static const UpdatePhraseThemeSQLClass:Class;
	private static const UPDATE_PHRASE_THEME_SQL:String = new UpdatePhraseThemeSQLClass();

	public function UpdatePhraseThemeSQLOperation(sqlRunner:SQLRunner, theme:Theme) {
		this.sqlRunner = sqlRunner;
		this.theme = theme;
	}

	private var sqlRunner:SQLRunner;
	private var theme:Theme;

	override public function process():void {
		if (theme && theme.id && theme.name) {
			var sqlParams:Object = {};
			sqlParams.themeID = theme.id;
			sqlParams.name = theme.name;

			sqlRunner.executeModify(Vector.<QueuedStatement>([new QueuedStatement(UPDATE_PHRASE_THEME_SQL, sqlParams)]), executeComplete, executeError);
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