package de.dittner.testmyself.ui.view.noteList.components.renderer {
import de.dittner.testmyself.ui.common.utils.AppColors;
import de.dittner.testmyself.ui.common.utils.FontName;

import flash.text.TextFormat;

public class ExampleRenderer extends NoteRenderer {
	private static const TITLE_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, 22, AppColors.TEXT_BLACK);
	private static const DESCRIPTION_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, 18, AppColors.TEXT_DARK);

	public function ExampleRenderer() {
		super();
		percentWidth = 100;
		minHeight = 30;
		showSeparatorWhenSelected = true;
	}

	override protected function createChildren():void {
		if (!descriptionTf) {
			descriptionTf = createMultilineTextField(DESCRIPTION_FORMAT);
			addChild(descriptionTf);
		}
		if (!titleTf) {
			titleTf = createMultilineTextField(TITLE_FORMAT);
			addChild(titleTf);
		}
		super.createChildren();
	}

	override protected function get pad():uint {return 15;}

	override protected function get gap():uint {return 10;}

}
}
