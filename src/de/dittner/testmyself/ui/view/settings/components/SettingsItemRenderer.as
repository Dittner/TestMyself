package de.dittner.testmyself.ui.view.settings.components {
import de.dittner.testmyself.ui.common.renderer.*;
import de.dittner.testmyself.ui.common.utils.AppColors;
import de.dittner.testmyself.ui.common.utils.FontName;
import de.dittner.testmyself.utils.Values;

import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFormat;

import spark.components.DataGroup;

public class SettingsItemRenderer extends ItemRendererBase {
	private static const FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, Values.PT20, AppColors.TEXT_DARK_GRAY, true);
	private static const PADDING:uint = Values.PT3;

	public function SettingsItemRenderer() {
		super();
	}

	private var tf:TextField;

	override protected function createChildren():void {
		super.createChildren();
		tf = createTextField(FORMAT);
		addChild(tf);
	}

	override protected function commitProperties():void {
		super.commitProperties();
		if (dataChanged) {
			dataChanged = false;
			tf.text = data ? data.label : "";
		}
	}

	override protected function measure():void {
		var dg:DataGroup = parent as DataGroup;
		measuredWidth = dg ? dg.width / dg.numElements : tf.textWidth + Values.PT10;
		minHeight = Values.PT10;
		measuredHeight = tf.textHeight + Values.PT5 + Values.PT2 * PADDING;
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.clear();

		if (selected) {
			g.beginFill(0xffFFff);
			g.drawRect(0, 0, w, h + 1);
			g.endFill();
		}
		else {
			g.beginFill(0xffFFff, 0.00001);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}

		tf.x = w - tf.textWidth >> 1;
		tf.y = PADDING;
		tf.width = w - 2 * PADDING;
		tf.height = h - 2 * PADDING;
	}

}
}
