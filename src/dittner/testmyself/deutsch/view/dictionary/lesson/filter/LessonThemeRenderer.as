package dittner.testmyself.deutsch.view.dictionary.lesson.filter {
import dittner.testmyself.core.model.theme.ITheme;
import dittner.testmyself.deutsch.view.common.renderer.*;
import dittner.testmyself.deutsch.view.common.utils.AppColors;
import dittner.testmyself.deutsch.view.common.utils.Fonts;

import flash.display.GradientType;
import flash.display.Graphics;
import flash.geom.Matrix;
import flash.text.TextField;
import flash.text.TextFormat;

public class LessonThemeRenderer extends ItemRendererBase {
	private static const FORMAT:TextFormat = new TextFormat(Fonts.ROBOTO_LIGHT_MX, 18, AppColors.TEXT_GRAY);
	private static const SELECTED_FORMAT:TextFormat = new TextFormat(Fonts.ROBOTO_LIGHT_MX, 18, AppColors.TEXT_WHITE);
	private static const PADDING:uint = 20;
	private static const HOVER_COLOR:uint = AppColors.LIST_ITEM_HOVER;

	public function LessonThemeRenderer() {
		super();
		percentWidth = 100;
	}

	private var themeName:TextField;

	private function get theme():ITheme {
		return data as ITheme;
	}

	override protected function createChildren():void {
		super.createChildren();
		themeName = createTextField(FORMAT);
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

	private var matr:Matrix = new Matrix();
	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.clear();

		if (selected) {
			themeName.setTextFormat(SELECTED_FORMAT);

			matr.createGradientBox(w, h, 90);
			g.beginGradientFill(GradientType.LINEAR, AppColors.LIST_ITEM_SELECTION, [1, 1], [0, 255], matr);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}
		else if (hovered) {
			themeName.setTextFormat(FORMAT);

			g.beginFill(HOVER_COLOR, 1);
			g.drawRect(0, 0, w, h);
			g.endFill();

			g.lineStyle(1, 0xccCCcc, .75);
			g.moveTo(0, h - 1);
			g.lineTo(w, h - 1);
		}
		else {
			themeName.setTextFormat(FORMAT);

			g.beginFill(0xffFFff, 0.00001);
			g.drawRect(0, 0, w, h);
			g.endFill();

			g.lineStyle(1, 0xccCCcc, .75);
			g.moveTo(0, h - 1);
			g.lineTo(w, h - 1);
		}

		themeName.x = themeName.y = PADDING;
		themeName.width = w - 2 * PADDING;
		themeName.height = h - 2 * PADDING;
	}

}
}
