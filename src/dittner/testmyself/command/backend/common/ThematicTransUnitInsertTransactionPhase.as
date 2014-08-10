package dittner.testmyself.command.backend.common {
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.operation.phaseOperation.PhaseOperation;
import dittner.testmyself.command.operation.phaseOperation.PhaseRunner;
import dittner.testmyself.model.common.TransUnit;
import dittner.testmyself.model.theme.Theme;

public class ThematicTransUnitInsertTransactionPhase extends PhaseOperation {

	[Embed(source="/dittner/testmyself/command/backend/phrase/sql/InsertThematicPhrase.sql", mimeType="application/octet-stream")]
	private static const InsertThematicPhraseSQLClass:Class;
	private static const INSERT_THEMATIC_PHRASE_SQL:String = new InsertThematicPhraseSQLClass();

	public function ThematicTransUnitInsertTransactionPhase(sqlRunner:SQLRunner, transUnit:TransUnit, themes:Array) {
		this.sqlRunner = sqlRunner;
		this.transUnit = transUnit;
		this.themes = themes;
	}

	private var transUnit:TransUnit;
	private var themes:Array;
	private var sqlRunner:SQLRunner;
	private var subPhaseRunner:PhaseRunner;

	override public function execute():void {
		if (themes.length > 0) {
			subPhaseRunner = new PhaseRunner();
			subPhaseRunner.completeCallback = dispatchComplete;

			for each(var theme:Theme in themes) {
				subPhaseRunner.addPhase(ThematicTransUnitInsertTransactionSubPhase, transUnit, theme, sqlRunner, INSERT_THEMATIC_PHRASE_SQL);
			}
			subPhaseRunner.execute();
		}
		else dispatchComplete();
	}
}
}
