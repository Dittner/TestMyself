package dittner.testmyself.command.backend.phrase {
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.operation.phaseOperation.PhaseOperation;
import dittner.testmyself.command.operation.phaseOperation.PhaseRunner;
import dittner.testmyself.model.phrase.Phrase;
import dittner.testmyself.model.theme.Theme;

public class PhraseFilterInsertTransactionPhase extends PhaseOperation {

	[Embed(source="/dittner/testmyself/command/backend/phrase/sql/InsertPhraseFilter.sql", mimeType="application/octet-stream")]
	private static const InsertPhraseFilterSQLClass:Class;
	private static const INSERT_PHRASE_FILTER_SQL:String = new InsertPhraseFilterSQLClass();

	public function PhraseFilterInsertTransactionPhase(sqlRunner:SQLRunner, phrase:Phrase, themes:Array) {
		this.sqlRunner = sqlRunner;
		this.phrase = phrase;
		this.themes = themes;
	}

	private var phrase:Phrase;
	private var themes:Array;
	private var sqlRunner:SQLRunner;
	private var subPhaseRunner:PhaseRunner;

	override public function execute():void {
		if (themes.length > 0) {
			subPhaseRunner = new PhaseRunner();
			subPhaseRunner.completeCallback = dispatchComplete;

			for each(var theme:Theme in themes) {
				subPhaseRunner.addPhase(PhraseFilterInsertTransactionSubPhase, phrase, theme, sqlRunner, INSERT_PHRASE_FILTER_SQL);
			}
			subPhaseRunner.execute();
		}
		else dispatchComplete();
	}
}
}
