package dittner.testmyself.deutsch.view.test.testList {
import dittner.testmyself.core.model.test.TestInfo;
import dittner.testmyself.deutsch.view.common.renderer.*;
import dittner.testmyself.deutsch.view.common.utils.AppColors;
import dittner.testmyself.deutsch.view.common.utils.FontName;

import flash.text.TextFormat;

public class TestInfoRenderer extends StringItemRenderer {
	private static const TEST_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, 20, AppColors.TEXT_BLACK, null, true);
	private static const TEST_SELECTED_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, 20, AppColors.TEXT_WHITE, null, true);

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
