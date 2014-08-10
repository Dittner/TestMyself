package dittner.testmyself.command.backend.phrase {
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.operation.result.CommandException;
import dittner.testmyself.command.operation.result.CommandResult;
import dittner.testmyself.command.operation.deferredOperation.DeferredOperation;
import dittner.testmyself.command.operation.phaseOperation.PhaseRunner;

public class DeletePhraseSQLOperation extends DeferredOperation {

	public function DeletePhraseSQLOperation(sqlRunner:SQLRunner, phraseID:int) {
		super();
		this.sqlRunner = sqlRunner;
		this.phraseID = phraseID;
	}

	private var sqlRunner:SQLRunner;
	private var phraseID:int;

	override public function process():void {
		var phaseRunner:PhaseRunner = new PhaseRunner();
		phaseRunner.completeCallback = phaseRunnerCompleteSuccessHandler;

		try {
			phaseRunner.addPhase(DeletePhraseTransactionPhase, sqlRunner, phraseID);
			phaseRunner.addPhase(DeleteThematicPhraseTransactionPhase, sqlRunner, phraseID);

			phaseRunner.execute();
		}
		catch (exc:CommandException) {
			phaseRunner.destroy();
			dispatchCompleteWithError(exc);
		}
	}

	private function phaseRunnerCompleteSuccessHandler():void {
		dispatchCompleteSuccess(CommandResult.OK);
	}

}
}