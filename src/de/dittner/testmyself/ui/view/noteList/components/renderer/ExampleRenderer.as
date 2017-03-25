package de.dittner.testmyself.ui.view.noteList.components.renderer {
import de.dittner.testmyself.ui.common.utils.AppColors;
import de.dittner.testmyself.ui.common.utils.FontName;
import de.dittner.testmyself.utils.Values;

import flash.text.TextFormat;

public class ExampleRenderer extends NoteRenderer {
	private static const TITLE_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, Values.PT22, AppColors.TEXT_BLACK);
	private static const DESCRIPTION_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, Values.PT20, AppColors.TEXT_DARK_GRAY);

	public function ExampleRenderer() {
		super();
		percentWidth = 100;
		minHeight = Values.PT30;
		showSeparatorWhenSelected = true;
	}

	override protected function createChildren():void {
		if (!descriptionTf) {
			descriptionTf = createMultilineTextField(DESCRIPTION_FORMAT);
			addChild(descriptionTf);
		}
		if (!titleTf) {
			titleTf = createMultilineTextField(TITLE_FORMAT, 50);
			addChild(titleTf);
		}
		super.createChildren();
	}

	override protected function get pad():uint {return Values.PT15;}

	override protected function get gap():uint {return Values.PT10;}

	override protected function updateText():void {
		titleTf.htmlText = note ? getTitle() : "";
		descriptionTf.htmlText = note ? getDescription() : "";
	}

}
}
