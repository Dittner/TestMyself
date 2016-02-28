package dittner.testmyself.deutsch.view.dictionary.lesson.filter {
import dittner.testmyself.core.model.theme.ITheme;
import dittner.testmyself.deutsch.view.common.renderer.*;
import dittner.testmyself.deutsch.view.common.utils.AppColors;
import dittner.testmyself.deutsch.view.common.utils.FontName;

import flash.text.TextFormat;

public class LessonThemeRenderer extends StringItemRenderer {
	private static const TEST_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, 20, AppColors.TEXT_BLACK, null, true);
	private static const TEST_SELECTED_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, 20, AppColors.TEXT_WHITE, null, true);

	public function LessonThemeRenderer() {
		super();
	}

	override protected function get text():String {
		return data is ITheme ? (data as ITheme).name : "";
	}

	override protected function get format():TextFormat {return TEST_FORMAT;}
	override protected function get selectedFormat():TextFormat {return TEST_SELECTED_FORMAT;}
	override protected function get horPad():uint {return 20;}
}
}
