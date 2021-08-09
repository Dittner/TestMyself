package de.dittner.testmyself.ui.view.noteList.components.tag {
import de.dittner.testmyself.model.domain.tag.Tag;
import de.dittner.testmyself.ui.common.renderer.*;
import de.dittner.testmyself.ui.common.utils.AppColors;
import de.dittner.testmyself.ui.common.utils.AppSizes;
import de.dittner.testmyself.ui.common.utils.FontName;
import de.dittner.testmyself.utils.Values;

import flash.text.TextFormat;

public class LargeTagRenderer extends StringItemRenderer {
	private static const TEST_FORMAT:TextFormat = new TextFormat(FontName.BASIC_MX, AppSizes.FONT_SIZE_SMALL, AppColors.BLACK, null, true);
	private static const TEST_SELECTED_FORMAT:TextFormat = new TextFormat(FontName.BASIC_MX, AppSizes.FONT_SIZE_SMALL, AppColors.TEXT_WHITE, null, true);

	public function LargeTagRenderer() {
		super();
	}

	override protected function get text():String {
		return data is Tag ? (data as Tag).name : "";
	}

	override protected function get format():TextFormat {return TEST_FORMAT;}
	override protected function get selectedFormat():TextFormat {return TEST_SELECTED_FORMAT;}
	override protected function get horPad():uint {return Values.PT15;}
}
}
