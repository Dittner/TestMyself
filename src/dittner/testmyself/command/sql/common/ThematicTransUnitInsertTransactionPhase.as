package dittner.testmyself.command.sql.common {
import com.probertson.data.SQLRunner;

import dittner.testmyself.model.common.TransUnit;
import dittner.testmyself.model.theme.Theme;
import dittner.testmyself.command.core.operation.PhaseOperation;
import dittner.testmyself.command.core.operation.PhaseRunner;

public class ThematicTransUnitInsertTransactionPhase extends PhaseOperation {
	public function ThematicTransUnitInsertTransactionPhase(transUnit:TransUnit, themes:Array, sqlRunner:SQLRunner, sqlStatement:String) {
		this.transUnit = transUnit;
		this.themes = themes;
		this.sqlRunner = sqlRunner;
		this.sqlStatement = sqlStatement;
	}

	private var transUnit:TransUnit;
	private var themes:Array;
	private var sqlRunner:SQLRunner;
	private var sqlStatement:String;

	private var subPhaseRunner:PhaseRunner;

	override public function execute():void {
		if (themes.length > 0) {
			subPhaseRunner = new PhaseRunner();
			subPhaseRunner.completeCallback = completeSuccess;
			subPhaseRunner.errorCallback = completeWithError;

			for each(var theme:Theme in themes) {
				subPhaseRunner.addPhase(ThematicTransUnitInsertTransactionSubPhase, transUnit, theme, sqlRunner, sqlStatement);
			}
			subPhaseRunner.execute();
		}
		else completeSuccess();
	}

}
}
