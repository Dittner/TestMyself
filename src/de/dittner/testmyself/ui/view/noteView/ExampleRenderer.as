package de.dittner.testmyself.ui.view.noteView {
import de.dittner.testmyself.ui.common.utils.AppColors;
import de.dittner.testmyself.ui.common.utils.AppSizes;
import de.dittner.testmyself.ui.common.utils.FontName;
import de.dittner.testmyself.ui.view.noteList.components.NoteRenderer;
import de.dittner.testmyself.utils.Values;

import flash.text.TextFormat;

public class ExampleRenderer extends NoteRenderer {
	private static const TITLE_FORMAT:TextFormat = new TextFormat(FontName.BASIC_MX, AppSizes.FONT_SIZE_SMALL, AppColors.BLACK, true);
	private static const DESCRIPTION_FORMAT:TextFormat = new TextFormat(FontName.BASIC_MX, AppSizes.FONT_SIZE_SMALL, AppColors.TEXT_DARK_GRAY);

	public function ExampleRenderer() {
		super();
		percentWidth = 100;
		minHeight = Values.PT30;
		cardViewMode = true;
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

	override protected function get horizontalPadding():uint {return 0;}
	override protected function get verticalPadding():uint {return Values.PT10;}

	override protected function get gap():uint {return 0;}

	override protected function updateText():void {
		titleTf.htmlText = note ? getTitle() : "";
		descriptionTf.htmlText = note ? getDescription() : "";
	}

}
}
