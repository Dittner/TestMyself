package de.dittner.testmyself.ui.view.settings.testSettings {
import de.dittner.testmyself.model.domain.test.Test;
import de.dittner.testmyself.ui.common.renderer.*;
import de.dittner.testmyself.ui.common.utils.AppColors;
import de.dittner.testmyself.ui.common.utils.FontName;

import flash.text.TextFormat;

public class SubjectTestInfoRenderer extends StringItemRenderer {
	private static const TEST_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, 20, AppColors.TEXT_BLACK, null, true);
	private static const TEST_SELECTED_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, 20, AppColors.TEXT_WHITE, null, true);

	public function SubjectTestInfoRenderer() {
		super();
	}

	override protected function get text():String {
		var test:Test = data as Test;
		return test ? moduleNameToStr(test.moduleName) + ". " + (data as Test).title : "";
	}

	private function moduleNameToStr(moduleName:String):String {
		switch (moduleName) {
			case ModuleName.WORD:
				return "Wörter";
			case ModuleName.VERB:
				return "Starke Verben";
			case ModuleName.LESSON:
				return "Übungen";
		}
		return "";
	}

	override protected function get format():TextFormat {return TEST_FORMAT;}
	override protected function get selectedFormat():TextFormat {return TEST_SELECTED_FORMAT;}
}
}
