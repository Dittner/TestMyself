package dittner.testmyself.deutsch.view.test.testList {
import dittner.testmyself.deutsch.view.common.renderer.StringItemRenderer;
import dittner.testmyself.deutsch.view.common.utils.AppColors;
import dittner.testmyself.deutsch.view.common.utils.Fonts;

import flash.text.TextFormat;

public class TestSubjectRenderer extends StringItemRenderer {
	private static const TEST_FORMAT:TextFormat = new TextFormat(Fonts.MYRIAD_MX, 20, AppColors.TEXT_BLACK);
	private static const TEST_SELECTED_FORMAT:TextFormat = new TextFormat(Fonts.MYRIAD_MX, 20, AppColors.TEXT_WHITE);

	public function TestSubjectRenderer() {
		super();
	}

	override protected function get format():TextFormat {return TEST_FORMAT;}
	override protected function get selectedFormat():TextFormat {return TEST_SELECTED_FORMAT;}
}
}
