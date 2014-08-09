package dittner.testmyself.command.backend.common {
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.core.phaseOperation.PhaseOperation;
import dittner.testmyself.command.core.phaseOperation.PhaseRunner;
import dittner.testmyself.model.theme.Theme;

public class ThemesInsertTransactionPhase extends PhaseOperation {
	public function ThemesInsertTransactionPhase(themes:Array, sqlRunner:SQLRunner, sqlStatement:String) {
		this.themes = themes;
		this.sqlRunner = sqlRunner;
		this.sqlStatement = sqlStatement;
	}

	private var themes:Array;
	private var sqlRunner:SQLRunner;
	private var sqlStatement:String;

	private var subPhaseRunner:PhaseRunner;
	private var addedThemes:Vector.<Theme>;

	override public function execute():void {
		addedThemes = getAddedThemes();
		if (addedThemes.length > 0) {
			subPhaseRunner = new PhaseRunner();
			subPhaseRunner.completeCallback = dispatchComplete;

			for each(var theme:Theme in addedThemes) {
				subPhaseRunner.addPhase(ThemeInsertTransactionSubPhase, theme, sqlRunner, sqlStatement);
			}
			subPhaseRunner.execute();
		}
		else dispatchComplete();
	}

	private function getAddedThemes():Vector.<Theme> {
		var res:Vector.<Theme> = new <Theme>[];

		for each(var theme:Theme in themes) {
			if (isNewTheme(theme)) res.push(theme);
		}
		return res;
	}

	private function isNewTheme(theme:Theme):Boolean {
		return theme.id == -1;
	}

	override public function destroy():void {
		super.destroy();
		themes = null;
		sqlRunner = null;
		addedThemes = null;
		sqlStatement = null;
		subPhaseRunner = null;
	}
}
}