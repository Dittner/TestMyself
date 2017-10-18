package de.dittner.testmyself.ui.view.noteList.components.tag {
import de.dittner.testmyself.model.domain.tag.Tag;
import de.dittner.testmyself.ui.common.renderer.*;
import de.dittner.testmyself.ui.common.utils.AppColors;
import de.dittner.testmyself.ui.common.utils.FontName;
import de.dittner.testmyself.utils.Values;

import flash.text.TextFormat;

public class TagRenderer extends StringItemRenderer {
	private static const TEST_FORMAT:TextFormat = new TextFormat(FontName.BASIC_MX, Values.PT18, AppColors.BLACK, null, true);
	private static const TEST_SELECTED_FORMAT:TextFormat = new TextFormat(FontName.BASIC_MX, Values.PT18, AppColors.TEXT_WHITE, null, true);

	public function TagRenderer() {
		super();
	}

	override protected function get format():TextFormat {return TEST_FORMAT;}
	override protected function get selectedFormat():TextFormat {return TEST_SELECTED_FORMAT;}

	override protected function get text():String {
		return data is Tag ? (data as Tag).name : "";
	}
}
}
