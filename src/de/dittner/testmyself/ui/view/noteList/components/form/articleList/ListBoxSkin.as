package de.dittner.testmyself.ui.view.noteList.components.form.articleList {
import de.dittner.testmyself.ui.common.tile.FadeTileButton;
import de.dittner.testmyself.ui.common.tile.TileID;
import de.dittner.testmyself.ui.common.utils.AppColors;
import de.dittner.testmyself.ui.common.utils.FontName;
import de.dittner.testmyself.ui.common.utils.TextFieldFactory;
import de.dittner.testmyself.utils.Values;

import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFormat;

import flashx.textLayout.formats.TextAlign;

import spark.skins.mobile.ListSkin;

public class ListBoxSkin extends ListSkin {
	private static const TITLE_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, Values.PT15, AppColors.TEXT_CONTROL_TITLE);
	private static const DROPDOWN_TEXT_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, Values.PT15, AppColors.TEXT_BLACK, null, null, null, null, null, TextAlign.CENTER);
	private static const TITLE_HEIGHT:uint = Values.PT20;
	private static const DROP_DOWN_BUTTON_HEIGHT:uint = Values.PT30;
	public function ListBoxSkin() {
		super();
	}

	public var dropDownBtn:FadeTileButton;
	public var dropDownTf:TextField;
	private var titleDisplay:TextField;

	override protected function createChildren():void {
		super.createChildren();
		dropDownBtn = new FadeTileButton();
		dropDownBtn.upTileID = TileID.BTN_DROPDOWN;
		addChild(dropDownBtn);

		addChild(titleDisplay = TextFieldFactory.create(TITLE_FORMAT));
		addChild(dropDownTf = TextFieldFactory.create(DROPDOWN_TEXT_FORMAT));
	}

	override protected function measure():void {
		super.measure();
		measuredHeight = Math.min(Values.PT500, dataGroup.getExplicitOrMeasuredHeight() + TITLE_HEIGHT + DROP_DOWN_BUTTON_HEIGHT + 1);
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);

		titleDisplay.text = resourceManager.getString('app', 'Article');
		titleDisplay.x = -2;
		titleDisplay.y = 0;

		dropDownTf.x = Values.PT2;
		dropDownTf.y = TITLE_HEIGHT + Values.PT3;
		dropDownTf.width = w - Values.PT3 - dropDownBtn.width;

		dropDownBtn.x = w - dropDownBtn.width;
		dropDownBtn.y = TITLE_HEIGHT;

		scroller.x = 1;
		scroller.y = dropDownBtn.height + dropDownBtn.y + 1;
		scroller.width = w - 2;
		scroller.height = h - scroller.y - 1;

		var g:Graphics = graphics;
		g.clear();
		g.lineStyle(1, AppColors.INPUT_BORDER);
		g.beginFill(AppColors.INPUT_CONTENT);
		g.drawRect(0, TITLE_HEIGHT, w - dropDownBtn.width - Values.PT1 - 1, dropDownBtn.height - 1);
		g.endFill();

		if (scroller.visible) {
			graphics.beginFill(AppColors.INPUT_CONTENT);
			graphics.drawRect(0, scroller.y, w - 1, Math.min(scroller.height, dataGroup.getExplicitOrMeasuredHeight()));
			graphics.endFill();
		}
	}
}
}