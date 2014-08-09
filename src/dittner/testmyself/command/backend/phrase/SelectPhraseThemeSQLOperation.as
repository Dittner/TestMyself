package dittner.testmyself.command.backend.phrase {
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.core.deferredOperation.DeferredOperation;
import dittner.testmyself.model.theme.Theme;

import flash.data.SQLResult;

public class SelectPhraseThemeSQLOperation extends DeferredOperation {

	[Embed(source="/dittner/testmyself/command/backend/phrase/sql/SelectPhraseTheme.sql", mimeType="application/octet-stream")]
	private static const SelectPhraseThemeSQLClass:Class;
	private static const SELECT_PHRASE_THEME_SQL:String = new SelectPhraseThemeSQLClass();

	public function SelectPhraseThemeSQLOperation(sqlRunner:SQLRunner, completeCallback:Function) {
		super();
		this.completeCallback = completeCallback;
		this.sqlRunner = sqlRunner;
	}

	private var sqlRunner:SQLRunner;
	private var completeCallback:Function;

	override public function process():void {
		sqlRunner.execute(SELECT_PHRASE_THEME_SQL, null, phraseThemesLoadedHandler, Theme);
	}

	private function phraseThemesLoadedHandler(result:SQLResult):void {
		completeCallback(result.data);
		dispatchComplete();
	}
}
}