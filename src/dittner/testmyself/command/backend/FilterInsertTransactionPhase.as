package dittner.testmyself.command.backend {
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.backend.phaseOperation.PhaseOperation;
import dittner.testmyself.command.backend.phaseOperation.PhaseRunner;
import dittner.testmyself.command.backend.utils.SQLFactory;
import dittner.testmyself.model.common.TransUnit;
import dittner.testmyself.model.theme.Theme;

public class FilterInsertTransactionPhase extends PhaseOperation {

	public function FilterInsertTransactionPhase(sqlRunner:SQLRunner, unit:TransUnit, themes:Array, sqlFactory:SQLFactory) {
		this.sqlRunner = sqlRunner;
		this.unit = unit;
		this.themes = themes;
		this.sqlFactory = sqlFactory;
	}

	private var unit:TransUnit;
	private var themes:Array;
	private var sqlFactory:SQLFactory;
	private var sqlRunner:SQLRunner;
	private var subPhaseRunner:PhaseRunner;

	override public function execute():void {
		if (themes.length > 0) {
			subPhaseRunner = new PhaseRunner();
			subPhaseRunner.completeCallback = dispatchComplete;

			for each(var theme:Theme in themes) {
				subPhaseRunner.addPhase(FilterInsertTransactionSubPhase, unit, theme, sqlRunner, sqlFactory.insertFilter);
			}
			subPhaseRunner.execute();
		}
		else dispatchComplete();
	}
}
}
