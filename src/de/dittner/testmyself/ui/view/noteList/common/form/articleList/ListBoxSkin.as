package de.dittner.testmyself.ui.view.noteList.common.form.articleList {
import de.dittner.testmyself.ui.common.utils.AppColors;
import de.dittner.testmyself.ui.common.utils.FontName;
import de.dittner.testmyself.ui.common.utils.TextFieldFactory;

import flash.text.TextField;
import flash.text.TextFormat;

import spark.components.Button;
import spark.skins.mobile.ListSkin;

public class ListBoxSkin extends ListSkin {
	private static const TITLE_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, 16, AppColors.TEXT_DARK);
	private static const TITLE_HEIGHT:uint = 20;
	private static const DROP_DOWN_BUTTON_HEIGHT:uint = 30;
	public function ListBoxSkin() {
		super();
	}

	public var dropDownBtn:Button;
	private var titleDisplay:TextField;

	override protected function createChildren():void {
		super.createChildren();
		addChild(dropDownBtn = new Button);
		addChild(titleDisplay = TextFieldFactory.create(TITLE_FORMAT));
		titleDisplay.thickness = 100;
		titleDisplay.text = "Artikel";
	}

	override protected function measure():void {
		super.measure();
		measuredHeight = Math.min(500, dataGroup.getExplicitOrMeasuredHeight() + TITLE_HEIGHT + DROP_DOWN_BUTTON_HEIGHT + 1);
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		titleDisplay.x = -2;
		titleDisplay.y = -2;

		dropDownBtn.styleName = "dropDownBtnStyle";
		dropDownBtn.height = DROP_DOWN_BUTTON_HEIGHT;
		dropDownBtn.width = w;
		dropDownBtn.y = TITLE_HEIGHT;

		scroller.x = 1;
		scroller.y = dropDownBtn.height + dropDownBtn.y + 1;
		scroller.width = w - 2;
		scroller.height = h - scroller.y - 1;

		graphics.clear();

		if (scroller.visible) {
			graphics.lineStyle(1, AppColors.INPUT_BORDER);
			graphics.beginFill(AppColors.INPUT_CONTENT);
			graphics.drawRect(0, scroller.y, w - 1, Math.min(scroller.height, dataGroup.getExplicitOrMeasuredHeight()));
			graphics.endFill();
		}
	}
}
}