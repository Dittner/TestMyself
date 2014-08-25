package dittner.testmyself.command.backend {
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.backend.deferredOperation.DeferredOperation;
import dittner.testmyself.command.backend.phaseOperation.PhaseRunner;
import dittner.testmyself.command.backend.result.CommandException;
import dittner.testmyself.command.backend.result.CommandResult;
import dittner.testmyself.command.backend.utils.SQLFactory;

public class DeleteThemeSQLOperation extends DeferredOperation {

	public function DeleteThemeSQLOperation(sqlRunner:SQLRunner, themeID:int, sqlFactory:SQLFactory) {
		super();
		this.sqlRunner = sqlRunner;
		this.themeID = themeID;
		this.sqlFactory = sqlFactory;
	}

	private var sqlRunner:SQLRunner;
	private var themeID:int;
	private var sqlFactory:SQLFactory;

	override public function process():void {
		var phaseRunner:PhaseRunner = new PhaseRunner();
		phaseRunner.completeCallback = phaseRunnerCompleteSuccessHandler;

		try {
			phaseRunner.addPhase(DeleteThemeTransactionPhase, sqlRunner, themeID, sqlFactory);
			phaseRunner.addPhase(DeleteFilterByIDTransactionPhase, sqlRunner, themeID, sqlFactory);

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