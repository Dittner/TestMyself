package de.dittner.testmyself.ui.view.noteList.components.form {
import de.dittner.testmyself.ui.common.utils.AppColors;
import de.dittner.testmyself.ui.common.utils.FontName;
import de.dittner.testmyself.ui.view.noteList.components.renderer.NoteRenderer;
import de.dittner.testmyself.utils.Values;

import flash.text.TextFormat;

public class ExamplesFormRenderer extends NoteRenderer {
	private static const TITLE_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, Values.PT18, AppColors.TEXT_BLACK);
	private static const DESCRIPTION_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, Values.PT18, AppColors.TEXT_DARK_GRAY);

	public function ExamplesFormRenderer() {
		super();
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

	override protected function get verticalPadding():uint {return Values.PT5;}
	override protected function get horizontalPadding():uint {return Values.PT5;}

	override protected function get gap():uint {return Values.PT5;}

	override protected function getTitleTextFormat():TextFormat {
		return TITLE_FORMAT;
	}
}
}
