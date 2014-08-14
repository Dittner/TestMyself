package dittner.testmyself.command.backend.phrase {
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.backend.common.MP3EncodingPhase;
import dittner.testmyself.command.backend.common.ThemesValidationPhase;
import dittner.testmyself.command.operation.deferredOperation.DeferredOperation;
import dittner.testmyself.command.operation.phaseOperation.PhaseRunner;
import dittner.testmyself.command.operation.result.CommandException;
import dittner.testmyself.command.operation.result.CommandResult;
import dittner.testmyself.model.phrase.Phrase;

public class InsertPhraseSQLOperation extends DeferredOperation {

	public function InsertPhraseSQLOperation(sqlRunner:SQLRunner, phrase:Phrase, phraseThemes:Array) {
		this.sqlRunner = sqlRunner;
		this.phrase = phrase;
		this.themes = phraseThemes;
	}

	private var sqlRunner:SQLRunner;
	private var phrase:Phrase;
	private var themes:Array;

	override public function process():void {
		var phaseRunner:PhaseRunner = new PhaseRunner();
		phaseRunner.completeCallback = phaseRunnerCompleteSuccessHandler;

		try {
			phaseRunner.addPhase(PhraseValidationPhase, phrase);
			phaseRunner.addPhase(ThemesValidationPhase, themes);
			phaseRunner.addPhase(MP3EncodingPhase, phrase);
			phaseRunner.addPhase(PhraseInsertTransactionPhase, sqlRunner, phrase);
			phaseRunner.addPhase(PhraseThemeInsertTransactionPhase, sqlRunner, themes);
			phaseRunner.addPhase(PhraseFilterInsertTransactionPhase, sqlRunner, phrase, themes);

			phaseRunner.execute();
		}
		catch (exc:CommandException) {
			phaseRunner.destroy();
			dispatchCompleteWithError(exc);
		}
	}

	private function phaseRunnerCompleteSuccessHandler():void {
		dispatchCompleteSuccess(new CommandResult(phrase));
	}
}
}