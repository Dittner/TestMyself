package dittner.testmyself.core.command.backend {
import com.probertson.data.SQLRunner;

import dittner.satelliteFlight.command.CommandException;
import dittner.satelliteFlight.command.CommandResult;
import dittner.testmyself.core.command.backend.deferredOperation.DeferredOperation;
import dittner.testmyself.core.command.backend.phaseOperation.PhaseRunner;
import dittner.testmyself.core.command.backend.utils.SQLFactory;
import dittner.testmyself.core.model.note.Note;

public class InsertNoteSQLOperation extends DeferredOperation {

	public function InsertNoteSQLOperation(sqlRunner:SQLRunner, note:Note, themes:Array, sqlFactory:SQLFactory) {
		this.sqlRunner = sqlRunner;
		this.note = note;
		this.themes = themes;
		this.sqlFactory = sqlFactory;
	}

	private var sqlRunner:SQLRunner;
	private var note:Note;
	private var themes:Array;
	private var sqlFactory:SQLFactory;

	override public function process():void {
		var phaseRunner:PhaseRunner = new PhaseRunner();
		phaseRunner.completeCallback = phaseRunnerCompleteSuccessHandler;

		try {
			phaseRunner.addPhase(NoteValidationPhase, note);
			phaseRunner.addPhase(ThemesValidationPhase, themes);
			phaseRunner.addPhase(MP3EncodingPhase, note);
			phaseRunner.addPhase(NoteInsertOperationPhase, sqlRunner, note, sqlFactory);
			phaseRunner.addPhase(ThemeInsertOperationPhase, sqlRunner, themes, sqlFactory);
			phaseRunner.addPhase(FilterInsertOperationPhase, sqlRunner, note, themes, sqlFactory);

			phaseRunner.execute();
		}
		catch (exc:CommandException) {
			phaseRunner.destroy();
			dispatchCompleteWithError(exc);
		}
	}

	private function phaseRunnerCompleteSuccessHandler():void {
		dispatchCompleteSuccess(new CommandResult(note));
	}
}
}