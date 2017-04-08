package de.dittner.testmyself.ui.view.test.testList {
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;
import de.dittner.testmyself.ui.common.renderer.StringItemRenderer;
import de.dittner.testmyself.ui.common.utils.AppColors;
import de.dittner.testmyself.ui.common.utils.FontName;
import de.dittner.testmyself.utils.Values;

import flash.text.TextFormat;

public class VocabularyRenderer extends StringItemRenderer {
	private static const TEST_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, Values.PT20, AppColors.BLACK);
	private static const TEST_SELECTED_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, Values.PT20, AppColors.TEXT_WHITE);

	public function VocabularyRenderer() {
		super();
	}

	override protected function get format():TextFormat {return TEST_FORMAT;}
	override protected function get selectedFormat():TextFormat {return TEST_SELECTED_FORMAT;}
	override protected function get text():String {
		return data is Vocabulary ? (data as Vocabulary).title : "";
	}
}
}
