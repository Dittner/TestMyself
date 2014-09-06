package dittner.testmyself.deutsch.view.common.input {
import dittner.testmyself.deutsch.view.common.utils.AppColors;
import dittner.testmyself.deutsch.view.common.utils.Fonts;
import dittner.testmyself.deutsch.view.common.utils.TextFieldFactory;

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

	private var lastWidth:Number = 0;
	private var lastHeight:Number = 0;

	override protected function updateDisplayList(w:Number, h:Number):void {
		var bgVerOffset:Number = hostInput.showTitle ? TITLE_HEIGHT : 0;
		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.clear();
		g.lineStyle(1, AppColors.INPUT_BORDER);
		g.beginFill(AppColors.INPUT_CONTENT);
		g.drawRect(0, bgVerOffset, w - 1, h - bgVerOffset - 1);
		g.endFill();

		titleDisplay.text = hostInput.title;
		titleDisplay.visible = hostInput.showTitle;
		titleDisplay.x = -2;
		titleDisplay.y = -2;
		titleDisplay.width = w;
		titleDisplay.height = TITLE_HEIGHT;

		setElementPosition(scroller, 0, bgVerOffset);
		setElementSize(scroller, w, h - bgVerOffset);

		if (w != lastWidth || h != lastHeight) {
			lastWidth = w;
			lastHeight = h;
			//если не сбросить скролл позишн, то текст из-за изменения позиции скроллера будет прокручен вверх
			if (scroller.viewport) scroller.viewport.verticalScrollPosition = 0;
		}

	}

}
}
