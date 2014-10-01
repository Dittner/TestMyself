package dittner.testmyself.deutsch.view.test.testList {
import dittner.testmyself.core.model.test.TestInfo;
import dittner.testmyself.deutsch.view.common.renderer.*;
import dittner.testmyself.deutsch.view.common.utils.AppColors;
import dittner.testmyself.deutsch.view.common.utils.Fonts;

import flash.text.TextFormat;

public class TestInfoRenderer extends StringItemRenderer {
	private static const TEST_FORMAT:TextFormat = new TextFormat(Fonts.ROBOTO_LIGHT_MX, 18, AppColors.TEXT_BLACK);
	private static const TEST_SELECTED_FORMAT:TextFormat = new TextFormat(Fonts.ROBOTO_LIGHT_MX, 18, AppColors.TEXT_WHITE);

	public function TestInfoRenderer() {
		super();
	}

	override protected function get text():String {
		return data is TestInfo ? (data as TestInfo).title : "";
	}

	override protected function get format():TextFormat {return TEST_FORMAT;}
	override protected function get selectedFormat():TextFormat {return TEST_SELECTED_FORMAT;}
}
}
