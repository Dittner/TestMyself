package dittner.testmyself.view.common.list {
import dittner.testmyself.view.common.utils.AppColors;
import dittner.testmyself.view.common.utils.Fonts;
import dittner.testmyself.view.common.utils.TextFieldFactory;

import flash.display.DisplayObject;
import flash.text.TextField;
import flash.text.TextFormat;

import spark.skins.mobile.ListSkin;

public class ListFormSkin extends ListSkin {

	private static const TITLE_FORMAT:TextFormat = new TextFormat(Fonts.VERDANAMX, 14, AppColors.TEXT_DARK);
	private static const TITLE_HEIGHT:uint = 20;

	[Embed(source="/assets/input/input_bg.png", scaleGridLeft='15', scaleGridRight='16', scaleGridTop='15', scaleGridBottom='16')]
	private static const BackgroundClass:Class;

	public function ListFormSkin() {
		super();
	}

	private var background:DisplayObject;
	private var titleDisplay:TextField;

	private function get hostInput():ListForm {return hostComponent as ListForm;}

	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------

	override protected function createChildren():void {
		background = new BackgroundClass();
		addChild(background);

		super.createChildren();

		titleDisplay = TextFieldFactory.create(TITLE_FORMAT);
		addChild(titleDisplay);
	}

	override protected function drawBackground(w:Number, h:Number):void {}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		background.y = hostInput.showTitle ? TITLE_HEIGHT : 0;
		background.height = h - background.y;
		background.width = w;

		titleDisplay.visible = hostInput.showTitle;
		titleDisplay.text = hostInput.title;
		titleDisplay.x = -2;
		titleDisplay.y = -2;
		titleDisplay.width = w;
		titleDisplay.height = TITLE_HEIGHT;

		scroller.x = 1;
		scroller.y = hostInput.showTitle ? TITLE_HEIGHT + 1 : 1;
		dataGroup.width = scroller.width = w - 2;
		scroller.height = h - scroller.y - 1;
	}

}
}