package de.dittner.testmyself.ui.common.input {
import de.dittner.testmyself.ui.common.renderer.*;
import de.dittner.testmyself.ui.common.utils.AppColors;
import de.dittner.testmyself.ui.common.utils.FontName;
import de.dittner.testmyself.utils.Values;

import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFormat;

public class DropdownListItemRenderer extends ItemRendererBase {

	private static const FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, Values.PT18, AppColors.TEXT_BLACK);
	private static const VPAD:uint = Values.PT5;
	private static const HPAD:uint = Values.PT5;

	public function DropdownListItemRenderer() {
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
		measuredHeight = tf.textHeight + Values.PT5 + 2 * verPad;
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.clear();

		if (selected) {
			tf.alpha = 1;
			g.beginFill(0, 0.00001);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}
		else if (hovered) {
			tf.alpha = 1;
			g.beginFill(0, 0.00001);
			g.drawRect(0, 0, w, h);
			g.endFill();

			g.lineStyle(1, 0x666666, .75);
			g.moveTo(HPAD, h - 1);
			g.lineTo(w - 2 * HPAD, h - 1);
		}
		else {
			tf.alpha = 0.6;
			tf.setTextFormat(format);

			g.beginFill(0, 0.00001);
			g.drawRect(0, 0, w, h);
			g.endFill();

			g.lineStyle(1, 0x666666, .75);
			g.moveTo(HPAD, h - 1);
			g.lineTo(w - 2 * HPAD, h - 1);
		}

		tf.x = horPad;
		tf.y = verPad;
		tf.width = w - 2 * horPad;
		tf.height = h - 2 * verPad;
	}

}
}
