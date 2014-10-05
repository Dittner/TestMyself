package dittner.testmyself.core.command.backend {
import dittner.satelliteFlight.command.CommandException;
import dittner.satelliteFlight.command.CommandResult;
import dittner.testmyself.core.command.backend.deferredOperation.DeferredOperation;
import dittner.testmyself.core.command.backend.phaseOperation.PhaseRunner;
import dittner.testmyself.core.model.note.NoteSuite;
import dittner.testmyself.core.model.test.TestModel;
import dittner.testmyself.core.service.NoteService;

public class InsertNoteSQLOperation extends DeferredOperation {

	public function InsertNoteSQLOperation(service:NoteService, suite:NoteSuite, testModel:TestModel) {
		this.service = service;
		this.suite = suite;
		this.testModel = testModel;
	}

	private var service:NoteService;
	private var suite:NoteSuite;
	private var testModel:TestModel;

	override public function process():void {
		var phaseRunner:PhaseRunner = new PhaseRunner();
		phaseRunner.completeCallback = phaseRunnerCompleteSuccessHandler;

		try {
			phaseRunner.addPhase(MP3EncodingPhase, suite.note);
			phaseRunner.addPhase(NoteInsertOperationPhase, service.sqlRunner, suite.note, service.sqlFactory);
			phaseRunner.addPhase(ThemeInsertOperationPhase, service.sqlRunner, suite.themes, service.sqlFactory);
			phaseRunner.addPhase(FilterInsertOperationPhase, service.sqlRunner, suite.note, suite.themes, service.sqlFactory);
			phaseRunner.addPhase(ExampleInsertOperationPhase, service.sqlRunner, suite.note, suite.examples, service.sqlFactory);
			phaseRunner.addPhase(TestTaskInsertOperationPhase, service.sqlRunner, suite.note, suite.examples, testModel, service.sqlFactory);

			phaseRunner.execute();
		}
		catch (exc:CommandException) {
			phaseRunner.destroy();
			dispatchCompleteWithError(exc);
		}
	}

	private function phaseRunnerCompleteSuccessHandler():void {
		dispatchCompleteSuccess(new CommandResult(suite));
	}
}
}