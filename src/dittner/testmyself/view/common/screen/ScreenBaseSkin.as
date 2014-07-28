package dittner.testmyself.view.common.screen {
import dittner.testmyself.view.common.utils.AppColors;
import dittner.testmyself.view.common.utils.FontName;

import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFormat;

import spark.skins.mobile.SkinnableContainerSkin;

public class ScreenBaseSkin extends SkinnableContainerSkin {
	private static const TITLE_FORMAT:TextFormat = new TextFormat(FontName.HELVETICA_NEUE_ULTRALIGHT, 24, 0x4e4f61);

	public function ScreenBaseSkin() {
		super();
	}

	public function get hostScreen():ScreenBase {return hostComponent as ScreenBase}

	public var titleTf:TextField;
	override protected function createChildren():void {
		titleTf = createTextField();
		titleTf.defaultTextFormat = TITLE_FORMAT;
		addChild(titleTf);
		super.createChildren();
	}

	protected static function createTextField():TextField {
		var textField:TextField = new TextField();
		textField.selectable = false;
		textField.multiline = false;
		textField.wordWrap = false;
		textField.mouseEnabled = false;
		textField.mouseWheelEnabled = false;
		return textField;
	}

	override protected function layoutContents(w:Number, h:Number):void {
		super.layoutContents(w, h);

		updateTitleText();
		titleTf.x = hostScreen.padding * 2;
		titleTf.y = (hostScreen.headerHeight - titleTf.textHeight - 5) / 2;
		titleTf.width = w - hostScreen.padding * 4;

		contentGroup.x = hostScreen.padding;
		contentGroup.y = 0;
		contentGroup.width = w - 2 * hostScreen.padding;
		contentGroup.height = h;
	}

	override protected function drawBackground(w:Number, h:Number):void {
		var g:Graphics = graphics;
		g.clear();
		if (hostScreen.showBackground) {
			g.beginFill(AppColors.SCREEN_CONTENT_BG, 1);
			g.drawRect(hostScreen.padding, 0, w - 2 * hostScreen.padding, h);
			g.endFill();
		}

		if (hostScreen.showHeader) {
			g.beginFill(AppColors.SCREEN_HEADER_BG, 1);
			g.drawRect(hostScreen.padding, 0, w - 2 * hostScreen.padding, hostScreen.headerHeight);
			g.endFill();
		}
	}

	private function updateTitleText():void {
		if (hostScreen) titleTf.text = hostScreen.info.title;
	}
}
}
