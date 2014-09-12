package dittner.testmyself.core.command.backend {
import dittner.satelliteFlight.command.CommandException;
import dittner.satelliteFlight.command.CommandResult;
import dittner.testmyself.core.command.backend.deferredOperation.DeferredOperation;
import dittner.testmyself.core.command.backend.phaseOperation.PhaseRunner;
import dittner.testmyself.core.model.note.NotesInfo;
import dittner.testmyself.core.service.NoteService;

public class GetDataBaseInfoSQLOperation extends DeferredOperation {

	public function GetDataBaseInfoSQLOperation(service:NoteService, filter:Array) {
		this.service = service;
		this.filter = filter;
		info = new NotesInfo();
	}

	private var service:NoteService;
	private var info:NotesInfo;
	private var filter:Array;

	override public function process():void {
		var phaseRunner:PhaseRunner = new PhaseRunner();
		phaseRunner.completeCallback = phaseRunnerCompleteSuccessHandler;

		try {
			phaseRunner.addPhase(NoteCountOperationPhase, service.sqlRunner, info, service.sqlFactory);
			phaseRunner.addPhase(FilteredNoteCountOperationPhase, service.sqlRunner, info, filter, service.sqlFactory);
			phaseRunner.addPhase(NoteWithAudioCountOperationPhase, service.sqlRunner, info, service.sqlFactory);
			phaseRunner.addPhase(ExampleCountOperationPhase, service.sqlRunner, info, service.sqlFactory);
			phaseRunner.addPhase(ExampleWithAudioCountOperationPhase, service.sqlRunner, info, service.sqlFactory);

			phaseRunner.execute();
		}
		catch (exc:CommandException) {
			phaseRunner.destroy();
			dispatchCompleteWithError(exc);
		}
	}

	private function phaseRunnerCompleteSuccessHandler():void {
		dispatchCompleteSuccess(new CommandResult(info));
	}
}
}