package dittner.testmyself.core.command.backend {
import dittner.satelliteFlight.command.CommandException;
import dittner.satelliteFlight.command.CommandResult;
import dittner.testmyself.core.command.backend.deferredOperation.DeferredOperation;
import dittner.testmyself.core.command.backend.phaseOperation.PhaseRunner;
import dittner.testmyself.core.model.test.TestModel;
import dittner.testmyself.core.service.NoteService;

public class RebuildTestTasksSQLOperation extends DeferredOperation {

	public function RebuildTestTasksSQLOperation(service:NoteService, testModel:TestModel, noteClass:Class) {
		this.service = service;
		this.testModel = testModel;
		this.noteClass = noteClass;
	}

	private var service:NoteService;
	private var testModel:TestModel;
	private var noteClass:Class;

	override public function process():void {
		var phaseRunner:PhaseRunner = new PhaseRunner();
		phaseRunner.completeCallback = phaseRunnerCompleteSuccessHandler;

		try {
			var notes:Array = [];
			var examples:Array = [];
			phaseRunner.addPhase(RecreateTestTablesOperationPhase, service.sqlRunner, service.sqlFactory);
			phaseRunner.addPhase(SelectAllNotesOperationPhase, service.sqlRunner, service.sqlFactory, notes, noteClass);
			phaseRunner.addPhase(AllTestTaskInsertOperationPhase, service.sqlRunner, notes, testModel, service.sqlFactory, false);

			phaseRunner.addPhase(SelectAllExamplesOperationPhase, service.sqlRunner, service.sqlFactory, examples);
			phaseRunner.addPhase(AllTestTaskInsertOperationPhase, service.sqlRunner, examples, testModel, service.sqlFactory, true);

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