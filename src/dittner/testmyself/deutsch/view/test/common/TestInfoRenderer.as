package dittner.testmyself.deutsch.view.test.common {
import dittner.testmyself.core.model.test.TestInfo;
import dittner.testmyself.deutsch.view.common.renderer.*;
import dittner.testmyself.deutsch.view.common.utils.AppColors;
import dittner.testmyself.deutsch.view.common.utils.Fonts;

import flash.display.GradientType;
import flash.display.Graphics;
import flash.geom.Matrix;
import flash.text.TextField;
import flash.text.TextFormat;

public class TestInfoRenderer extends ItemRendererBase {
	private static const FORMAT:TextFormat = new TextFormat(Fonts.ROBOTO_MX, 14, AppColors.TEXT_GRAY);
	private static const SELECTED_FORMAT:TextFormat = new TextFormat(Fonts.ROBOTO_MX, 14, AppColors.TEXT_WHITE);
	private static const PADDING:uint = 3;
	private static const HOVER_COLOR:uint = AppColors.LIST_ITEM_HOVER;

	public function TestInfoRenderer() {
		super();
		percentWidth = 100;
	}

	private var tf:TextField;

	private function get testInfo():TestInfo {
		return data as TestInfo;
	}

	override protected function createChildren():void {
		super.createChildren();
		tf = createTextField(FORMAT);
		addChild(tf);
	}

	override protected function commitProperties():void {
		super.commitProperties();
		if (dataChanged) {
			dataChanged = false;
			tf.text = testInfo ? testInfo.title : "";
		}
	}

	override protected function measure():void {
		measuredMinWidth = measuredWidth = parent ? parent.width : 50;
		minHeight = 10;
		measuredHeight = tf.textHeight + 5 + 2 * PADDING;
	}

	private var matr:Matrix = new Matrix();
	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.clear();

		if (selected) {
			tf.setTextFormat(SELECTED_FORMAT);

			matr.createGradientBox(w, h, 90);
			g.beginGradientFill(GradientType.LINEAR, AppColors.LIST_ITEM_SELECTION, [1, 1], [0, 255], matr);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}
		else if (hovered) {
			tf.setTextFormat(FORMAT);

			g.beginFill(HOVER_COLOR, 1);
			g.drawRect(0, 0, w, h);
			g.endFill();

			g.lineStyle(1, 0xccCCcc, .75);
			g.moveTo(0, h - 1);
			g.lineTo(w, h - 1);
		}
		else {
			tf.setTextFormat(FORMAT);

			g.beginFill(0xffFFff, 0.00001);
			g.drawRect(0, 0, w, h);
			g.endFill();

			g.lineStyle(1, 0xccCCcc, .75);
			g.moveTo(0, h - 1);
			g.lineTo(w, h - 1);
		}

		tf.x = tf.y = PADDING;
		tf.width = w - 2 * PADDING;
		tf.height = h - 2 * PADDING;
	}

}
}
