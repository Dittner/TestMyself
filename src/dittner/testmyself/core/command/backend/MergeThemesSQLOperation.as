package dittner.testmyself.core.command.backend {
import dittner.satelliteFlight.command.CommandException;
import dittner.satelliteFlight.command.CommandResult;
import dittner.testmyself.core.command.backend.deferredOperation.DeferredOperation;
import dittner.testmyself.core.command.backend.phaseOperation.PhaseRunner;
import dittner.testmyself.core.service.NoteService;

public class MergeThemesSQLOperation extends DeferredOperation {

	public function MergeThemesSQLOperation(service:NoteService, destThemeID:int, srcThemeID:int) {
		super();
		this.service = service;
		this.destThemeID = destThemeID;
		this.srcThemeID = srcThemeID;
	}

	private var service:NoteService;
	private var destThemeID:int;
	private var srcThemeID:int;

	override public function process():void {
		var phaseRunner:PhaseRunner = new PhaseRunner();
		phaseRunner.completeCallback = phaseRunnerCompleteSuccessHandler;

		try {
			phaseRunner.addPhase(DeleteThemeOperationPhase, service.sqlRunner, srcThemeID, service.sqlFactory);
			phaseRunner.addPhase(UpdateFilterOperationPhase, service.sqlRunner, destThemeID, srcThemeID, service.sqlFactory);

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