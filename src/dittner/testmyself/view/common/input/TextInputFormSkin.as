package dittner.testmyself.view.common.input {
import dittner.testmyself.view.common.utils.AppColors;
import dittner.testmyself.view.common.utils.Fonts;
import dittner.testmyself.view.common.utils.TextFieldFactory;

import flash.display.DisplayObject;
import flash.text.TextField;
import flash.text.TextFormat;

import spark.skins.mobile.TextInputSkin;

public class TextInputFormSkin extends TextInputSkin {
	private static const TITLE_FORMAT:TextFormat = new TextFormat(Fonts.ROBOTO_MX, 14, AppColors.TEXT_DARK);
	private static const TITLE_HEIGHT:uint = 20;

	public function TextInputFormSkin() {
	}

	[Embed(source="/assets/input/input_bg.png", scaleGridLeft='15', scaleGridRight='16', scaleGridTop='15', scaleGridBottom='16')]
	private static const BackgroundClass:Class;

	private var background:DisplayObject;
	private var titleDisplay:TextField;

	private function get hostInput():TextInputForm {return hostComponent as TextInputForm;}

	override protected function createChildren():void {
		background = new BackgroundClass();
		addChild(background);
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

		background.y = hostInput.showTitle ? TITLE_HEIGHT : 0;
		background.height = h - background.y;
		background.width = w;

		titleDisplay.visible = hostInput.showTitle;
		titleDisplay.text = hostInput.title;
		titleDisplay.x = -2;
		titleDisplay.y = -2;
		titleDisplay.width = w;
		titleDisplay.height = TITLE_HEIGHT;
	}

}
}
