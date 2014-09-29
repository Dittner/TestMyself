package dittner.testmyself.deutsch.view.test.testList {
import dittner.testmyself.deutsch.view.common.renderer.ItemRendererBase;
import dittner.testmyself.deutsch.view.common.utils.AppColors;
import dittner.testmyself.deutsch.view.common.utils.Fonts;

import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFormat;

import flashx.textLayout.formats.TextAlign;

public class TestSeparatorRenderer extends ItemRendererBase {
	private static const FORMAT:TextFormat = new TextFormat(Fonts.ROBOTO_MX, 14, AppColors.TEXT_WHITE);

	public function TestSeparatorRenderer() {
		super();
		mouseChildren = mouseEnabled = false;
	}

	private static const PADDING:uint = 10;

	private var tf:TextField;
	override protected function createChildren():void {
		super.createChildren();
		FORMAT.align = TextAlign.CENTER;
		tf = createTextField(FORMAT);
		addChild(tf);
	}

	override protected function commitProperties():void {
		super.commitProperties();
		if (dataChanged) {
			dataChanged = false;
			tf.text = data is String ? data as String : "";
		}
	}

	override protected function measure():void {
		measuredMinWidth = measuredWidth = parent ? parent.width : tf.textWidth + 2 * PADDING;
		measuredHeight = 30;
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.clear();
		g.beginFill(0);
		g.drawRect(0, 1, w, h - 1);
		g.endFill();

		tf.x = PADDING;
		tf.y = (h - tf.textHeight >> 1) - 1;
		tf.width = w - 2 * PADDING;
		tf.height = tf.textHeight + 2;
	}
}
}
