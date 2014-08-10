package dittner.testmyself.command.backend.common {
import com.probertson.data.SQLRunner;

import dittner.testmyself.command.operation.phaseOperation.PhaseOperation;
import dittner.testmyself.command.operation.phaseOperation.PhaseRunner;
import dittner.testmyself.model.theme.Theme;

public class ThemesInsertTransactionPhase extends PhaseOperation {

	[Embed(source="/dittner/testmyself/command/backend/phrase/sql/InsertPhraseTheme.sql", mimeType="application/octet-stream")]
	private static const InsertPhraseThemeSQLClass:Class;
	private static const INSERT_PHRASE_THEME_SQL:String = new InsertPhraseThemeSQLClass();

	public function ThemesInsertTransactionPhase(sqlRunner:SQLRunner, themes:Array) {
		this.sqlRunner = sqlRunner;
		this.themes = themes;
	}

	private var themes:Array;
	private var sqlRunner:SQLRunner;
	private var subPhaseRunner:PhaseRunner;

	override public function execute():void {
		var addedThemes:Vector.<Theme> = getAddedThemes();
		if (addedThemes.length > 0) {
			subPhaseRunner = new PhaseRunner();
			subPhaseRunner.completeCallback = dispatchComplete;

			for each(var theme:Theme in addedThemes) {
				subPhaseRunner.addPhase(ThemeInsertTransactionSubPhase, theme, sqlRunner, INSERT_PHRASE_THEME_SQL);
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