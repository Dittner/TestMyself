package de.dittner.testmyself.ui.common.list {
import de.dittner.testmyself.ui.common.utils.AppColors;
import de.dittner.testmyself.ui.common.utils.FontName;
import de.dittner.testmyself.ui.common.utils.TextFieldFactory;

import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFormat;

import spark.skins.mobile.ListSkin;

public class ListFormSkin extends ListSkin {

	private static const TITLE_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, 15, AppColors.TEXT_CONTROL_TITLE);
	private static const TITLE_HEIGHT:uint = 20;

	public function ListFormSkin() {
		super();
	}

	private var titleDisplay:TextField;
	private function get hostInput():ListForm {return hostComponent as ListForm;}

	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------

	override protected function createChildren():void {
		super.createChildren();
		titleDisplay = TextFieldFactory.create(TITLE_FORMAT);
		addChild(titleDisplay);
	}

	override protected function measure():void {
		measuredWidth = scroller.getPreferredBoundsWidth();
		measuredHeight = Math.max(scroller.getPreferredBoundsHeight(), dataGroup.getExplicitOrMeasuredHeight());
		measuredHeight += hostInput.showTitle ? TITLE_HEIGHT : 0;
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
		titleDisplay.y = 0;
		titleDisplay.width = w;
		titleDisplay.height = TITLE_HEIGHT;

		scroller.x = 1;
		scroller.y = hostInput.showTitle ? TITLE_HEIGHT + 1 : 1;
		dataGroup.width = w - 2;
		scroller.width = w - 2 + 20;//otherwise its blocking right side of content
		scroller.height = h - scroller.y - 1;
	}

}
}