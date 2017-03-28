package de.dittner.testmyself.ui.common.renderer {
import de.dittner.testmyself.ui.common.utils.AppColors;
import de.dittner.testmyself.ui.common.utils.FontName;
import de.dittner.testmyself.utils.Values;

import flash.display.GradientType;
import flash.display.Graphics;
import flash.geom.Matrix;
import flash.text.TextField;
import flash.text.TextFormat;

public class StringItemRenderer extends ItemRendererBase {
	private static const FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, Values.PT16, AppColors.TEXT_BLACK);
	private static const SELECTED_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, Values.PT16, AppColors.TEXT_WHITE);
	private static const VPAD:uint = Values.PT8;
	private static const HPAD:uint = Values.PT5;

	public function StringItemRenderer() {
		super();
		percentWidth = 100;
	}

	private var tf:TextField;

	protected function get text():String {
		return data is String ? data as String : "";
	}

	override protected function createChildren():void {
		super.createChildren();
		tf = createTextField(format);
		addChild(tf);
	}

	protected function get format():TextFormat {return FORMAT;}
	protected function get selectedFormat():TextFormat {return SELECTED_FORMAT;}
	protected function get verPad():uint {return VPAD;}
	protected function get horPad():uint {return HPAD;}

	override protected function commitProperties():void {
		super.commitProperties();
		if (dataChanged) {
			dataChanged = false;
			tf.text = text;
		}
	}

	override protected function measure():void {
		measuredMinWidth = measuredWidth = parent ? parent.width : Values.PT50;
		minHeight = Values.PT10;
		measuredHeight = Math.ceil(tf.textHeight + Values.PT4 + 2 * verPad);
	}

	private var matr:Matrix = new Matrix();
	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.clear();

		if (selected) {
			tf.setTextFormat(selectedFormat);
			tf.alpha = 1;
			matr.createGradientBox(w, h, Math.PI / 2);
			g.beginGradientFill(GradientType.LINEAR, AppColors.LIST_ITEM_SELECTION, [1, 1], [0, 255], matr);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}
		else if (hovered) {
			tf.setTextFormat(format);
			tf.alpha = 1;
			g.beginFill(0xffFFff, 0.00001);
			g.drawRect(0, 0, w, h);
			g.endFill();


			g.beginFill(AppColors.REN_SEP_COLOR);
			g.drawRect(0, h-1, w, 1);
			g.endFill();
		}
		else {
			tf.alpha = 0.6;
			tf.setTextFormat(format);

			g.beginFill(0xffFFff, 0.00001);
			g.drawRect(0, 0, w, h);
			g.endFill();

			g.beginFill(AppColors.REN_SEP_COLOR);
			g.drawRect(0, h-1, w, 1);
			g.endFill();
		}

		tf.x = horPad;
		tf.y = verPad;
		tf.width = w - 2 * horPad;
		tf.height = h - 2 * verPad;
	}

}
}
