package dittner.testmyself.command.backend.phrase {
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.operation.result.CommandResult;
import dittner.testmyself.command.operation.deferredOperation.DeferredOperation;
import dittner.testmyself.model.theme.Theme;

import flash.data.SQLResult;

public class SelectPhraseThemeSQLOperation extends DeferredOperation {

	[Embed(source="/dittner/testmyself/command/backend/phrase/sql/SelectPhraseTheme.sql", mimeType="application/octet-stream")]
	private static const SelectPhraseThemeSQLClass:Class;
	private static const SELECT_PHRASE_THEME_SQL:String = new SelectPhraseThemeSQLClass();

	public function SelectPhraseThemeSQLOperation(sqlRunner:SQLRunner) {
		super();
		this.sqlRunner = sqlRunner;
	}

	private var sqlRunner:SQLRunner;

	override public function process():void {
		sqlRunner.execute(SELECT_PHRASE_THEME_SQL, null, phraseThemesLoadedHandler, Theme);
	}

	private function phraseThemesLoadedHandler(result:SQLResult):void {
		dispatchCompleteSuccess(new CommandResult(result.data));
	}
}
}