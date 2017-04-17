package de.dittner.testmyself.ui.view.settings.components {
import de.dittner.testmyself.ui.common.renderer.*;
import de.dittner.testmyself.ui.common.utils.AppColors;
import de.dittner.testmyself.ui.common.utils.FontName;
import de.dittner.testmyself.utils.Values;

import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFormat;

import flashx.textLayout.formats.TextAlign;

import spark.components.DataGroup;

public class SettingsItemRenderer extends ItemRendererBase {
	private static const FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, Values.PT20, AppColors.TEXT_DARK_GRAY, true, null, null, null, null, TextAlign.CENTER);

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
		measuredWidth = Math.ceil(dg ? dg.width / dg.numElements : tf.textWidth + Values.PT10);
		measuredHeight = Values.PT40;
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.clear();

		tf.textColor = selected ? AppColors.TEXT_WHITE : AppColors.TEXT_DARK_GRAY;

		if (selected) {
			g.beginFill(0, 0.6);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}
		else {
			g.beginFill(0, 0.00001);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}

		tf.y = h - tf.textHeight >> 1;
		tf.width = w;
		tf.height = h - tf.y;
	}

}
}
