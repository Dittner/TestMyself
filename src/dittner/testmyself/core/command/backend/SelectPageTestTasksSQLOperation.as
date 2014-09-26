package dittner.testmyself.core.command.backend {
import dittner.satelliteFlight.command.CommandException;
import dittner.satelliteFlight.command.CommandResult;
import dittner.testmyself.core.command.backend.deferredOperation.DeferredOperation;
import dittner.testmyself.core.command.backend.phaseOperation.PhaseRunner;
import dittner.testmyself.core.model.page.TestPageInfo;
import dittner.testmyself.core.service.NoteService;

public class SelectPageTestTasksSQLOperation extends DeferredOperation {

	public function SelectPageTestTasksSQLOperation(service:NoteService, pageInfo:TestPageInfo, noteClass:Class) {
		super();
		this.service = service;
		this.pageInfo = pageInfo;
		this.noteClass = noteClass;
	}

	private var service:NoteService;
	private var pageInfo:TestPageInfo;
	private var noteClass:Class;

	override public function process():void {
		var phaseRunner:PhaseRunner = new PhaseRunner();
		phaseRunner.completeCallback = phaseRunnerCompleteSuccessHandler;

		try {
			phaseRunner.addPhase(SelectPageTestTasksOperationPhase, service.sqlRunner, pageInfo, service.sqlFactory);
			phaseRunner.addPhase(SelectPageTestNotesOperationPhase, service.sqlRunner, pageInfo, service.sqlFactory, noteClass);
			phaseRunner.execute();
		}
		catch (exc:CommandException) {
			phaseRunner.destroy();
			dispatchCompleteWithError(exc);
		}
	}

	private function phaseRunnerCompleteSuccessHandler():void {
		dispatchCompleteSuccess(new CommandResult(pageInfo));
	}
}
}