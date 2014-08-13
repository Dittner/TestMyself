package dittner.testmyself.view.common.renderer {
import dittner.testmyself.model.theme.ITheme;
import dittner.testmyself.view.common.utils.AppColors;
import dittner.testmyself.view.common.utils.Fonts;

import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFormat;

public class ThemeItemRenderer extends ItemRendererBase {
	private static const THEME_FORMAT:TextFormat = new TextFormat(Fonts.ROBOTO_MX, 14, AppColors.TEXT_GRAY);
	private static const SELECTED_THEME_FORMAT:TextFormat = new TextFormat(Fonts.ROBOTO_MX, 14, AppColors.TEXT_WHITE);
	private static const PADDING:uint = 3;
	private static const HOVER_COLOR:uint = AppColors.LIST_ITEM_HOVER;
	private static const SELECTED_COLOR:uint = AppColors.LIST_ITEM_SELECTION;

	public function ThemeItemRenderer() {
		super();
		percentWidth = 100;
	}

	private var themeName:TextField;

	private function get theme():ITheme {
		return data as ITheme;
	}

	override protected function createChildren():void {
		super.createChildren();
		themeName = createTextField(THEME_FORMAT);
		addChild(themeName);
	}

	override protected function commitProperties():void {
		super.commitProperties();
		if (dataChanged) {
			dataChanged = false;
			themeName.text = theme ? theme.name : "";
		}
	}

	override protected function measure():void {
		measuredMinWidth = measuredWidth = parent ? parent.width : 50;
		minHeight = 10;
		measuredHeight = themeName.textHeight + 5 + 2 * PADDING;
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.clear();
		var bgColor:uint = 0;
		var bgAlpha:Number = 1;

		if (selected) {
			bgColor = SELECTED_COLOR;
			themeName.setTextFormat(SELECTED_THEME_FORMAT);
		}
		else if (hovered) {
			bgColor = HOVER_COLOR;
			themeName.setTextFormat(THEME_FORMAT);
		}
		else {
			bgColor = 0xffFFff;
			bgAlpha = 0.00001;
			themeName.setTextFormat(THEME_FORMAT);
		}

		g.beginFill(bgColor, bgAlpha);
		g.drawRect(0, 0, w, h);
		g.endFill();

		g.lineStyle(1, selected ? 0x555555 : 0xccCCcc, 1);
		g.moveTo(0, h - 1);
		g.lineTo(w, h - 1);

		themeName.x = themeName.y = PADDING;
		themeName.width = w - 2 * PADDING;
		themeName.height = h - 2 * PADDING;
	}

}
}
