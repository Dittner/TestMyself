package dittner.testmyself.core.command.backend {
import com.probertson.data.SQLRunner;

import dittner.satelliteFlight.command.CommandException;
import dittner.satelliteFlight.command.CommandResult;
import dittner.testmyself.core.command.backend.deferredOperation.DeferredOperation;
import dittner.testmyself.core.command.backend.phaseOperation.PhaseRunner;
import dittner.testmyself.core.command.backend.utils.SQLFactory;
import dittner.testmyself.core.model.note.NoteSuite;

public class UpdateNoteSQLOperation extends DeferredOperation {

	public function UpdateNoteSQLOperation(sqlRunner:SQLRunner, suite:NoteSuite, sqlFactory:SQLFactory) {
		this.sqlRunner = sqlRunner;
		this.suite = suite;
		this.sqlFactory = sqlFactory;
	}

	private var sqlRunner:SQLRunner;
	private var suite:NoteSuite;
	private var sqlFactory:SQLFactory;

	override public function process():void {
		var phaseRunner:PhaseRunner = new PhaseRunner();
		phaseRunner.completeCallback = phaseRunnerCompleteSuccessHandler;

		try {
			phaseRunner.addPhase(MP3EncodingPhase, suite.note);
			phaseRunner.addPhase(NoteUpdateOperationPhase, sqlRunner, suite.note, sqlFactory);
			phaseRunner.addPhase(DeleteFilterByNoteIDOperationPhase, sqlRunner, suite.note.id, sqlFactory);
			phaseRunner.addPhase(ThemeInsertOperationPhase, sqlRunner, suite.themes, sqlFactory);
			phaseRunner.addPhase(FilterInsertOperationPhase, sqlRunner, suite.note, suite.themes, sqlFactory);

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