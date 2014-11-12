package dittner.testmyself.deutsch.view.settings.testSettings {
import dittner.testmyself.core.model.test.TestInfo;
import dittner.testmyself.deutsch.model.ModuleName;
import dittner.testmyself.deutsch.view.common.renderer.*;
import dittner.testmyself.deutsch.view.common.utils.AppColors;
import dittner.testmyself.deutsch.view.common.utils.Fonts;

import flash.text.TextFormat;

public class SubjectTestInfoRenderer extends StringItemRenderer {
	private static const TEST_FORMAT:TextFormat = new TextFormat(Fonts.ROBOTO_LIGHT_MX, 18, AppColors.TEXT_BLACK);
	private static const TEST_SELECTED_FORMAT:TextFormat = new TextFormat(Fonts.ROBOTO_LIGHT_MX, 18, AppColors.TEXT_WHITE);

	public function SubjectTestInfoRenderer() {
		super();
	}

	override protected function get text():String {
		var test:TestInfo = data as TestInfo;
		return test ? moduleNameToStr(test.moduleName) + ". " + (data as TestInfo).title : "";
	}

	private function moduleNameToStr(moduleName:String):String {
		switch (moduleName) {
			case ModuleName.WORD:
				return "Слова";
			case ModuleName.PHRASE:
				return "Фразы";
			case ModuleName.VERB:
				return "Глаголы";
			case ModuleName.LESSON:
				return "Уроки";
		}
		return "";
	}

	override protected function get format():TextFormat {return TEST_FORMAT;}
	override protected function get selectedFormat():TextFormat {return TEST_SELECTED_FORMAT;}
}
}
