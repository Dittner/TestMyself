package dittner.testmyself.deutsch.view.common.input {
import dittner.testmyself.deutsch.view.common.utils.AppColors;
import dittner.testmyself.deutsch.view.common.utils.Fonts;
import dittner.testmyself.deutsch.view.common.utils.TextFieldFactory;

import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFormat;

import spark.skins.mobile.TextInputSkin;

public class TextInputFormSkin extends TextInputSkin {
	private static const TITLE_FORMAT:TextFormat = new TextFormat(Fonts.ROBOTO_MX, 14, AppColors.TEXT_DARK);
	private static const TITLE_HEIGHT:uint = 20;

	public function TextInputFormSkin() {
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
		measuredHeight = hostInput.showTitle ? TITLE_HEIGHT + 30 : 30;
	}

	override protected function drawBackground(w:Number, h:Number):void {}

	override protected function layoutContents(w:Number, h:Number):void {
		var textHeight:Number = getElementPreferredHeight(textDisplay);

		if (hostInput.showTitle) {
			textDisplay.y = TITLE_HEIGHT + Math.round((h - TITLE_HEIGHT - textHeight) / 2);
			textDisplay.height = h - textDisplay.y - 2;
		}
		else {
			textDisplay.y = Math.round((h - textHeight) / 2);
			textDisplay.height = h - textDisplay.y - 2;
		}

		textDisplay.x = 5;
		textDisplay.width = w - 10;

		var bgVerOffset:Number = hostInput.showTitle ? TITLE_HEIGHT : 0;
		var g:Graphics = graphics;
		g.clear();
		g.lineStyle(1, AppColors.INPUT_BORDER);
		g.beginFill(AppColors.INPUT_CONTENT);
		g.drawRect(0, bgVerOffset, w - 1, h - bgVerOffset - 1);
		g.endFill();

		titleDisplay.visible = hostInput.showTitle;
		titleDisplay.text = hostInput.title;
		titleDisplay.x = -2;
		titleDisplay.y = -2;
		titleDisplay.width = w;
		titleDisplay.height = TITLE_HEIGHT;
	}

}
}
