package dittner.testmyself.command.backend.phrase {
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.operation.deferredOperation.DeferredOperation;
import dittner.testmyself.command.operation.phaseOperation.PhaseRunner;
import dittner.testmyself.command.operation.result.CommandException;
import dittner.testmyself.command.operation.result.CommandResult;

public class DeletePhraseThemeSQLOperation extends DeferredOperation {

	public function DeletePhraseThemeSQLOperation(sqlRunner:SQLRunner, themeID:int) {
		super();
		this.sqlRunner = sqlRunner;
		this.themeID = themeID;
	}

	private var sqlRunner:SQLRunner;
	private var themeID:int;

	override public function process():void {
		var phaseRunner:PhaseRunner = new PhaseRunner();
		phaseRunner.completeCallback = phaseRunnerCompleteSuccessHandler;

		try {
			phaseRunner.addPhase(DeletePhraseThemeTransactionPhase, sqlRunner, themeID);
			phaseRunner.addPhase(DeletePhraseFilterByFilterTransactionPhase, sqlRunner, themeID);

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