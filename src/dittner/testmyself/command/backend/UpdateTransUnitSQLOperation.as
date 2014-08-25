package dittner.testmyself.command.backend {
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.backend.deferredOperation.DeferredOperation;
import dittner.testmyself.command.backend.phaseOperation.PhaseRunner;
import dittner.testmyself.command.backend.result.CommandException;
import dittner.testmyself.command.backend.result.CommandResult;
import dittner.testmyself.command.backend.utils.SQLFactory;
import dittner.testmyself.model.common.TransUnit;

public class UpdateTransUnitSQLOperation extends DeferredOperation {

	public function UpdateTransUnitSQLOperation(sqlRunner:SQLRunner, transUnit:TransUnit, origin:TransUnit, themes:Array, sqlFactory:SQLFactory) {
		this.sqlRunner = sqlRunner;
		this.transUnit = transUnit;
		this.origin = origin;
		this.themes = themes;
		this.sqlFactory = sqlFactory;
	}

	private var sqlRunner:SQLRunner;
	private var transUnit:TransUnit;
	private var origin:TransUnit;
	private var themes:Array;
	private var sqlFactory:SQLFactory;

	override public function process():void {
		var phaseRunner:PhaseRunner = new PhaseRunner();
		phaseRunner.completeCallback = phaseRunnerCompleteSuccessHandler;

		try {
			phaseRunner.addPhase(TransUnitValidationPhase, transUnit);
			phaseRunner.addPhase(ThemesValidationPhase, themes);
			phaseRunner.addPhase(MP3EncodingPhase, transUnit, origin);
			phaseRunner.addPhase(TransUnitUpdateTransactionPhase, sqlRunner, transUnit, sqlFactory);
			phaseRunner.addPhase(DeleteFilterByTransUnitIDTransactionPhase, sqlRunner, transUnit.id, sqlFactory);
			phaseRunner.addPhase(ThemeInsertTransactionPhase, sqlRunner, themes, sqlFactory);
			phaseRunner.addPhase(FilterInsertTransactionPhase, sqlRunner, transUnit, themes, sqlFactory);

			phaseRunner.execute();
		}
		catch (exc:CommandException) {
			phaseRunner.destroy();
			dispatchCompleteWithError(exc);
		}
	}

	private function phaseRunnerCompleteSuccessHandler():void {
		dispatchCompleteSuccess(new CommandResult(transUnit));
	}
}
}