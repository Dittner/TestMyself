package dittner.testmyself.core.command.backend {
import com.probertson.data.SQLRunner;

import dittner.satelliteFlight.command.CommandException;
import dittner.satelliteFlight.command.CommandResult;
import dittner.testmyself.core.command.backend.deferredOperation.DeferredOperation;
import dittner.testmyself.core.command.backend.phaseOperation.PhaseRunner;
import dittner.testmyself.core.command.backend.utils.SQLFactory;

public class MergeThemesSQLOperation extends DeferredOperation {

	public function MergeThemesSQLOperation(sqlRunner:SQLRunner, destThemeID:int, srcThemeID:int, sqlFactory:SQLFactory) {
		super();
		this.sqlRunner = sqlRunner;
		this.destThemeID = destThemeID;
		this.srcThemeID = srcThemeID;
		this.sqlFactory = sqlFactory;
	}

	private var sqlRunner:SQLRunner;
	private var destThemeID:int;
	private var srcThemeID:int;
	private var sqlFactory:SQLFactory;

	override public function process():void {
		var phaseRunner:PhaseRunner = new PhaseRunner();
		phaseRunner.completeCallback = phaseRunnerCompleteSuccessHandler;

		try {
			phaseRunner.addPhase(DeleteThemeOperationPhase, sqlRunner, srcThemeID, sqlFactory);
			phaseRunner.addPhase(UpdateFilterOperationPhase, sqlRunner, destThemeID, srcThemeID, sqlFactory);

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