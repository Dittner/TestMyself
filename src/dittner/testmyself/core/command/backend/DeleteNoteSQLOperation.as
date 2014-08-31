package dittner.testmyself.core.command.backend {
import com.probertson.data.SQLRunner;

import dittner.satelliteFlight.command.CommandException;
import dittner.satelliteFlight.command.CommandResult;
import dittner.testmyself.core.command.backend.deferredOperation.DeferredOperation;
import dittner.testmyself.core.command.backend.phaseOperation.PhaseRunner;
import dittner.testmyself.core.command.backend.utils.SQLFactory;

public class DeleteNoteSQLOperation extends DeferredOperation {

	public function DeleteNoteSQLOperation(sqlRunner:SQLRunner, noteID:int, sqlFactory:SQLFactory) {
		super();
		this.sqlRunner = sqlRunner;
		this.noteID = noteID;
		this.sqlFactory = sqlFactory;
	}

	private var sqlRunner:SQLRunner;
	private var noteID:int;
	private var sqlFactory:SQLFactory;

	override public function process():void {
		var phaseRunner:PhaseRunner = new PhaseRunner();
		phaseRunner.completeCallback = phaseRunnerCompleteSuccessHandler;

		try {
			phaseRunner.addPhase(DeleteNoteOperationPhase, sqlRunner, noteID, sqlFactory);
			phaseRunner.addPhase(DeleteFilterByNoteIDOperationPhase, sqlRunner, noteID, sqlFactory);

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