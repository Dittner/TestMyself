package dittner.testmyself.command.backend.phrase {
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.backend.common.ThematicTransUnitInsertTransactionPhase;
import dittner.testmyself.command.backend.common.ThemesInsertTransactionPhase;
import dittner.testmyself.command.backend.common.ThemesValidationPhase;
import dittner.testmyself.command.backend.common.exception.CommandException;
import dittner.testmyself.command.core.deferredOperation.DeferredOperation;
import dittner.testmyself.command.core.phaseOperation.PhaseRunner;
import dittner.testmyself.model.phrase.Phrase;

public class InsertPhraseSQLOperation extends DeferredOperation {

	[Embed(source="/dittner/testmyself/command/backend/phrase/sql/InsertPhrase.sql", mimeType="application/octet-stream")]
	private static const InsertPhraseSQLClass:Class;
	private static const INSERT_PHRASE_SQL:String = new InsertPhraseSQLClass();

	[Embed(source="/dittner/testmyself/command/backend/phrase/sql/InsertThematicPhrase.sql", mimeType="application/octet-stream")]
	private static const InsertThematicPhraseSQLClass:Class;
	private static const INSERT_THEMATIC_PHRASE_SQL:String = new InsertThematicPhraseSQLClass();

	[Embed(source="/dittner/testmyself/command/backend/phrase/sql/InsertPhraseTheme.sql", mimeType="application/octet-stream")]
	private static const InsertPhraseThemeSQLClass:Class;
	private static const INSERT_PHRASE_THEME_SQL:String = new InsertPhraseThemeSQLClass();

	//----------------------------------------------------------------------------------------------
	//
	//  Constructor
	//
	//----------------------------------------------------------------------------------------------

	public function InsertPhraseSQLOperation(sqlRunner:SQLRunner, phrase:Phrase, phraseThemes:Array) {
		this.sqlRunner = sqlRunner;
		this.phrase = phrase;
		this.themes = phraseThemes;
	}

	private var sqlRunner:SQLRunner;
	private var phrase:Phrase;
	private var themes:Array;

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override public function process():void {
		var phaseRunner:PhaseRunner = new PhaseRunner();
		phaseRunner.completeCallback = phaseRunnerCompleteSuccessHandler;

		try {
			phaseRunner.addPhase(PhraseValidationPhase, phrase);
			phaseRunner.addPhase(ThemesValidationPhase, themes);
			phaseRunner.addPhase(PhraseInsertTransactionPhase, phrase, sqlRunner, INSERT_PHRASE_SQL);
			phaseRunner.addPhase(ThemesInsertTransactionPhase, themes, sqlRunner, INSERT_PHRASE_THEME_SQL);
			phaseRunner.addPhase(ThematicTransUnitInsertTransactionPhase, phrase, themes, sqlRunner, INSERT_THEMATIC_PHRASE_SQL);

			phaseRunner.execute();
		}
		catch (exc:CommandException) {
			phaseRunner.destroy();
			dispatchCompletWithError(exc);
		}
	}

	private function phaseRunnerCompleteSuccessHandler():void {
		dispatchCompleteSuccess(phrase);
	}

}
}
