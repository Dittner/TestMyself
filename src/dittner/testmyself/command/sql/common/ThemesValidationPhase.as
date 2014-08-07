package dittner.testmyself.command.sql.common {
import dittner.testmyself.model.theme.Theme;
import dittner.testmyself.command.core.operation.PhaseOperation;
import dittner.testmyself.command.core.operation.SQLErrorCode;

public class ThemesValidationPhase extends PhaseOperation {
	public function ThemesValidationPhase(themes:Array) {
		this.themes = themes;
	}

	private var themes:Array;

	override public function execute():void {
		if (themes) {
			if (haveThemesWithEmptyName()) completeWithError(SQLErrorCode.EMPTY_THEME_NAME);
			else completeSuccess();
		}
		else {
			completeWithError(SQLErrorCode.NULL_THEMES);
		}
	}

	private function haveThemesWithEmptyName():Boolean {
		for each(var theme:Theme in themes) {
			if (!theme.name) return true;
		}
		return false;
	}

	override protected function destroy():void {
		super.destroy();
		themes = null;
	}
}
}
