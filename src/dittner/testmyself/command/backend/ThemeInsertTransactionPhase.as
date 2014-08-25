package dittner.testmyself.command.backend {
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.backend.phaseOperation.PhaseOperation;
import dittner.testmyself.command.backend.phaseOperation.PhaseRunner;
import dittner.testmyself.command.backend.utils.SQLFactory;
import dittner.testmyself.model.theme.Theme;

public class ThemeInsertTransactionPhase extends PhaseOperation {

	public function ThemeInsertTransactionPhase(sqlRunner:SQLRunner, themes:Array, sqlFactory:SQLFactory) {
		this.sqlRunner = sqlRunner;
		this.themes = themes;
		this.sqlFactory = sqlFactory;
	}

	private var themes:Array;
	private var sqlRunner:SQLRunner;
	private var sqlFactory:SQLFactory;
	private var subPhaseRunner:PhaseRunner;

	override public function execute():void {
		var addedThemes:Vector.<Theme> = getAddedThemes();
		if (addedThemes.length > 0) {
			subPhaseRunner = new PhaseRunner();
			subPhaseRunner.completeCallback = dispatchComplete;

			for each(var theme:Theme in addedThemes) {
				subPhaseRunner.addPhase(ThemeInsertTransactionSubPhase, theme, sqlRunner, sqlFactory.insertTheme);
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
		subPhaseRunner = null;
	}
}
}