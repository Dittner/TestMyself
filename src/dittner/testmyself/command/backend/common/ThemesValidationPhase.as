package dittner.testmyself.command.backend.common {
import dittner.testmyself.command.operation.result.CommandException;
import dittner.testmyself.command.operation.deferredOperation.ErrorCode;
import dittner.testmyself.command.operation.phaseOperation.PhaseOperation;
import dittner.testmyself.model.theme.Theme;

public class ThemesValidationPhase extends PhaseOperation {
	public function ThemesValidationPhase(themes:Array) {
		this.themes = themes;
	}

	private var themes:Array;

	override public function execute():void {
		if (themes) {
			if (haveThemesWithEmptyName())
				throw new CommandException(ErrorCode.EMPTY_THEME_NAME, "Отсутствует имя у созданной темы");
			else
				dispatchComplete();
		}
		else {
			throw new CommandException(ErrorCode.NULL_THEMES, "Отсутствуют темы у объекта, ожидается пустой или заполненный массив тем");
		}
	}

	private function haveThemesWithEmptyName():Boolean {
		for each(var theme:Theme in themes) {
			if (!theme.name) return true;
		}
		return false;
	}

	override public function destroy():void {
		super.destroy();
		themes = null;
	}
}
}