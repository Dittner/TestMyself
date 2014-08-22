package dittner.testmyself.view.common.input {
import dittner.testmyself.view.common.utils.AppColors;
import dittner.testmyself.view.common.utils.Fonts;
import dittner.testmyself.view.common.utils.TextFieldFactory;

import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFormat;

import spark.skins.mobile.TextAreaSkin;

public class TextAreaFormSkin extends TextAreaSkin {
	private static const TITLE_FORMAT:TextFormat = new TextFormat(Fonts.ROBOTO_MX, 14, AppColors.TEXT_DARK);
	private static const TITLE_HEIGHT:uint = 20;

	public function TextAreaFormSkin() {super(); }

	private var titleDisplay:TextField;
	private function get hostInput():TextAreaForm {return hostComponent as TextAreaForm;}

	override protected function createChildren():void {
		super.createChildren();

		titleDisplay = TextFieldFactory.create(TITLE_FORMAT);
		addChild(titleDisplay);
	}

	override protected function drawBackground(w:Number, h:Number):void {}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);

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

		setElementPosition(scroller, 0, bgVerOffset);
		setElementSize(scroller, w, h - bgVerOffset);
	}

}
}
