package de.dittner.testmyself.ui.common.input {
import de.dittner.testmyself.ui.common.utils.AppColors;
import de.dittner.testmyself.ui.common.utils.FontName;
import de.dittner.testmyself.ui.common.utils.TextFieldFactory;
import de.dittner.testmyself.utils.Values;

import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFormat;

import spark.skins.mobile.TextInputSkin;

public class MobileTextInputFormSkin extends TextInputSkin {
	private static const TITLE_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, Values.PT15, AppColors.TEXT_CONTROL_TITLE);
	private static const TITLE_HEIGHT:uint = Values.PT20;

	public function MobileTextInputFormSkin() {
		super();
	}

	private var titleDisplay:TextField;
	private function get hostInput():TextInputForm {return hostComponent as TextInputForm;}

	override protected function createChildren():void {
		super.createChildren();

		titleDisplay = TextFieldFactory.create(TITLE_FORMAT);
		addChild(titleDisplay);
	}

	override protected function measure():void {
		super.measure();
		measuredHeight = hostInput.showTitle ? TITLE_HEIGHT + Values.PT30 : Values.PT30;
	}

	override protected function drawBackground(w:Number, h:Number):void {}

	override protected function layoutContents(w:Number, h:Number):void {
		var textHeight:Number = getElementPreferredHeight(textDisplay);

		if (hostInput.showTitle) {
			setElementSize(textDisplay, w - Values.PT10, textHeight);
			setElementPosition(textDisplay, 7, TITLE_HEIGHT + Math.round((h - TITLE_HEIGHT - textHeight) / 2));
		}
		else {
			setElementSize(textDisplay, w - Values.PT10, h - textDisplay.y - 2);
			setElementPosition(textDisplay, Values.PT5, Math.round((h - textHeight) / 2));
		}

		var bgVerOffset:Number = hostInput.showTitle ? TITLE_HEIGHT : 0;
		var g:Graphics = graphics;
		g.clear();
		g.lineStyle(1, hostInput.isValidInput ? AppColors.INPUT_BORDER : AppColors.INVALID_INPUT_BORDER);
		g.beginFill(AppColors.INPUT_CONTENT);
		g.drawRect(0, bgVerOffset, w - 1, h - bgVerOffset - 1);
		g.endFill();

		titleDisplay.visible = hostInput.showTitle;
		titleDisplay.text = hostInput.title;
		titleDisplay.x = -2;
		titleDisplay.y = 0;
		titleDisplay.width = w;
		titleDisplay.height = TITLE_HEIGHT;
	}

}
}
