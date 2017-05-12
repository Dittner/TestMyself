package de.dittner.testmyself.ui.view.noteView {
import de.dittner.testmyself.model.Device;
import de.dittner.testmyself.ui.common.renderer.*;
import de.dittner.testmyself.ui.common.utils.AppColors;
import de.dittner.testmyself.ui.common.utils.FontName;
import de.dittner.testmyself.utils.Values;

import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFormat;

public class KeyWordRenderer extends ItemRendererBase {
	private static const FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, Values.PT18, AppColors.WHITE, true);
	private static const VPAD:uint = Values.PT5;
	private static const HPAD:uint = Values.PT5;

	public function KeyWordRenderer() {
		super();
		percentWidth = 100;
	}

	private var tf:TextField;

	protected function get text():String {
		return data is String ? data as String : "";
	}

	override protected function createChildren():void {
		super.createChildren();
		tf = createTextField(FORMAT);
		tf.mouseEnabled = Device.isDesktop;
		tf.selectable = Device.isDesktop;
		addChild(tf);
	}

	override protected function commitProperties():void {
		super.commitProperties();
		if (dataChanged) {
			dataChanged = false;
			tf.text = text;
		}
	}

	override protected function measure():void {
		measuredMinWidth = tf.textWidth + 2 * HPAD;
		measuredHeight = tf.textHeight + 2 * VPAD;
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.clear();

		g.beginFill(0);
		g.drawRect(0, 0, w, h);
		g.endFill();

		tf.x = HPAD;
		tf.y = VPAD - 2;
		tf.width = w - HPAD;
		tf.height = h - VPAD;
	}

}
}
