package dittner.testmyself.core.command.backend {
import com.probertson.data.SQLRunner;

import dittner.testmyself.core.command.backend.phaseOperation.PhaseOperation;
import dittner.testmyself.core.command.backend.phaseOperation.PhaseRunner;
import dittner.testmyself.core.command.backend.utils.SQLFactory;
import dittner.testmyself.core.model.theme.Theme;

public class ThemeInsertOperationPhase extends PhaseOperation {

	public function ThemeInsertOperationPhase(sqlRunner:SQLRunner, themes:Array, sqlFactory:SQLFactory) {
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
				subPhaseRunner.addPhase(ThemeInsertOperationSubPhase, theme, sqlRunner, sqlFactory.insertTheme);
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