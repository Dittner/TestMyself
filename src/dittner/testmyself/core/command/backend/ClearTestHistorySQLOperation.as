package dittner.testmyself.core.command.backend {
import dittner.satelliteFlight.command.CommandException;
import dittner.satelliteFlight.command.CommandResult;
import dittner.testmyself.core.command.backend.deferredOperation.DeferredOperation;
import dittner.testmyself.core.command.backend.phaseOperation.PhaseRunner;
import dittner.testmyself.core.model.test.TestInfo;
import dittner.testmyself.core.model.test.TestModel;
import dittner.testmyself.core.service.NoteService;

public class ClearTestHistorySQLOperation extends DeferredOperation {

	public function ClearTestHistorySQLOperation(service:NoteService, testInfo:TestInfo, testModel:TestModel) {
		this.service = service;
		this.testInfo = testInfo;
		this.testModel = testModel;
	}

	private var service:NoteService;
	private var testInfo:TestInfo;
	private var testModel:TestModel;

	override public function process():void {
		var phaseRunner:PhaseRunner = new PhaseRunner();
		phaseRunner.completeCallback = phaseRunnerCompleteSuccessHandler;

		try {
			var notesIDs:Array = [];
			phaseRunner.addPhase(SelectTestNotesIDsOperationPhase, service.sqlRunner, testInfo, service.sqlFactory, notesIDs);
			phaseRunner.addPhase(ClearTestHistoryOperationPhase, service.sqlRunner, testInfo, notesIDs, testModel, service.sqlFactory);

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