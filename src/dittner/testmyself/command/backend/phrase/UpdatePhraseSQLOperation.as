package dittner.testmyself.command.backend.phrase {
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.backend.common.ThematicTransUnitInsertTransactionPhase;
import dittner.testmyself.command.backend.common.ThemesInsertTransactionPhase;
import dittner.testmyself.command.backend.common.ThemesValidationPhase;
import dittner.testmyself.command.operation.deferredOperation.DeferredOperation;
import dittner.testmyself.command.operation.phaseOperation.PhaseRunner;
import dittner.testmyself.command.operation.result.CommandException;
import dittner.testmyself.command.operation.result.CommandResult;
import dittner.testmyself.model.phrase.Phrase;

public class UpdatePhraseSQLOperation extends DeferredOperation {

	public function UpdatePhraseSQLOperation(sqlRunner:SQLRunner, phrase:Phrase, phraseThemes:Array) {
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
			phaseRunner.addPhase(PhraseUpdateTransactionPhase, sqlRunner, phrase);
			phaseRunner.addPhase(DeleteThematicPhraseTransactionPhase, sqlRunner, phrase.id);
			phaseRunner.addPhase(ThemesInsertTransactionPhase, sqlRunner, themes);
			phaseRunner.addPhase(ThematicTransUnitInsertTransactionPhase, sqlRunner, phrase, themes);

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