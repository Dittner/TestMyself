package dittner.testmyself.core.command.backend {
import com.probertson.data.SQLRunner;

import dittner.satelliteFlight.command.CommandException;
import dittner.satelliteFlight.command.CommandResult;
import dittner.testmyself.core.command.backend.deferredOperation.DeferredOperation;
import dittner.testmyself.core.command.backend.phaseOperation.PhaseRunner;
import dittner.testmyself.core.model.note.NotesInfo;
import dittner.testmyself.core.model.note.SQLFactory;

public class GetDataBaseInfoSQLOperation extends DeferredOperation {

	public function GetDataBaseInfoSQLOperation(sqlRunner:SQLRunner, filter:Array, sqlFactory:SQLFactory) {
		this.sqlRunner = sqlRunner;
		this.filter = filter;
		this.sqlFactory = sqlFactory;
		info = new NotesInfo();
	}

	private var sqlRunner:SQLRunner;
	private var info:NotesInfo;
	private var filter:Array;
	private var sqlFactory:SQLFactory;

	override public function process():void {
		var phaseRunner:PhaseRunner = new PhaseRunner();
		phaseRunner.completeCallback = phaseRunnerCompleteSuccessHandler;

		try {
			phaseRunner.addPhase(NoteCountOperationPhase, sqlRunner, info, sqlFactory);
			phaseRunner.addPhase(FilteredNoteCountOperationPhase, sqlRunner, info, filter, sqlFactory);
			phaseRunner.addPhase(NoteWithAudioCountOperationPhase, sqlRunner, info, sqlFactory);
			phaseRunner.addPhase(ExampleCountOperationPhase, sqlRunner, info, sqlFactory);
			phaseRunner.addPhase(ExampleWithAudioCountOperationPhase, sqlRunner, info, sqlFactory);

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