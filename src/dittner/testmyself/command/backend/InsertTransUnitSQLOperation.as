package dittner.testmyself.command.backend {
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.backend.deferredOperation.DeferredOperation;
import dittner.testmyself.command.backend.phaseOperation.PhaseRunner;
import dittner.testmyself.command.backend.result.CommandException;
import dittner.testmyself.command.backend.result.CommandResult;
import dittner.testmyself.command.backend.utils.SQLFactory;
import dittner.testmyself.model.common.TransUnit;

public class InsertTransUnitSQLOperation extends DeferredOperation {

	public function InsertTransUnitSQLOperation(sqlRunner:SQLRunner, unit:TransUnit, themes:Array, sqlFactory:SQLFactory) {
		this.sqlRunner = sqlRunner;
		this.unit = unit;
		this.themes = themes;
		this.sqlFactory = sqlFactory;
	}

	private var sqlRunner:SQLRunner;
	private var unit:TransUnit;
	private var themes:Array;
	private var sqlFactory:SQLFactory;

	override public function process():void {
		var phaseRunner:PhaseRunner = new PhaseRunner();
		phaseRunner.completeCallback = phaseRunnerCompleteSuccessHandler;

		try {
			phaseRunner.addPhase(TransUnitValidationPhase, unit);
			phaseRunner.addPhase(ThemesValidationPhase, themes);
			phaseRunner.addPhase(MP3EncodingPhase, unit);
			phaseRunner.addPhase(TransUnitInsertTransactionPhase, sqlRunner, unit, sqlFactory);
			phaseRunner.addPhase(ThemeInsertTransactionPhase, sqlRunner, themes, sqlFactory);
			phaseRunner.addPhase(FilterInsertTransactionPhase, sqlRunner, unit, themes, sqlFactory);

			phaseRunner.execute();
		}
		catch (exc:CommandException) {
			phaseRunner.destroy();
			dispatchCompleteWithError(exc);
		}
	}

	private function phaseRunnerCompleteSuccessHandler():void {
		dispatchCompleteSuccess(new CommandResult(unit));
	}
}
}