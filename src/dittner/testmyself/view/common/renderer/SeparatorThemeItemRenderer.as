package dittner.testmyself.view.common.renderer {
import dittner.testmyself.view.common.utils.AppColors;
import dittner.testmyself.view.common.utils.Fonts;

import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFormat;

public class SeparatorThemeItemRenderer extends ItemRendererBase {
	private static const TITLE_FORMAT:TextFormat = new TextFormat(Fonts.VERDANAMX, 14, AppColors.TEXT_GRAY_LIGHT);

	public function SeparatorThemeItemRenderer() {
		super();
		percentWidth = 100;
		mouseEnabled = mouseChildren = false;
	}

	private var titleTf:TextField;

	override protected function createChildren():void {
		super.createChildren();
		TITLE_FORMAT.align = "center";
		titleTf = createTextField(TITLE_FORMAT);
		titleTf.text = "Новые темы";
		addChild(titleTf);
	}

	override protected function measure():void {
		measuredMinWidth = measuredWidth = parent ? parent.width : 50;
		measuredHeight = 30;
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.clear();

		titleTf.x = -2;
		titleTf.y = h - titleTf.textHeight >> 1;
		titleTf.width = w;

		g.beginFill(AppColors.SCREEN_CONTENT_BG);
		g.drawRect(0, 0, w, h);
		g.endFill();

	}
}
}
