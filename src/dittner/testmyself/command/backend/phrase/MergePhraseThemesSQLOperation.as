package dittner.testmyself.command.backend.phrase {
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.operation.deferredOperation.DeferredOperation;
import dittner.testmyself.command.operation.phaseOperation.PhaseRunner;
import dittner.testmyself.command.operation.result.CommandException;
import dittner.testmyself.command.operation.result.CommandResult;

public class MergePhraseThemesSQLOperation extends DeferredOperation {

	public function MergePhraseThemesSQLOperation(sqlRunner:SQLRunner, destThemeID:int, srcThemeID:int) {
		super();
		this.sqlRunner = sqlRunner;
		this.destThemeID = destThemeID;
		this.srcThemeID = srcThemeID;
	}

	private var sqlRunner:SQLRunner;
	private var destThemeID:int;
	private var srcThemeID:int;

	override public function process():void {
		var phaseRunner:PhaseRunner = new PhaseRunner();
		phaseRunner.completeCallback = phaseRunnerCompleteSuccessHandler;

		try {
			phaseRunner.addPhase(DeletePhraseThemeTransactionPhase, sqlRunner, srcThemeID);
			phaseRunner.addPhase(UpdatePhraseFilterTransactionPhase, sqlRunner, destThemeID, srcThemeID);

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