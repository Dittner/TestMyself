package de.dittner.testmyself.ui.common.input {
import de.dittner.testmyself.ui.common.renderer.*;
import de.dittner.testmyself.ui.common.utils.AppColors;
import de.dittner.testmyself.ui.common.utils.FontName;
import de.dittner.testmyself.utils.Values;

import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFormat;

public class DropdownListItemRenderer extends ItemRendererBase {
	private static const INDEX_FORMAT:TextFormat = new TextFormat(FontName.BASIC_MX, Values.PT15, AppColors.TEXT_GRAY);
	private static const TITLE_FORMAT:TextFormat = new TextFormat(FontName.BASIC_MX, Values.PT20, AppColors.TEXT_DARK_GRAY);
	private static const VPAD:uint = Values.PT5;
	private static const HPAD:uint = Values.PT5;

	public function DropdownListItemRenderer() {
		super();
		percentWidth = 100;
	}

	private var indexTf:TextField;
	private var tf:TextField;

	protected function get text():String {
		return data is String ? data as String : "";
	}

	override protected function createChildren():void {
		super.createChildren();
		indexTf = createMultilineTextField(INDEX_FORMAT);
		addChild(indexTf);
		tf = createMultilineTextField(TITLE_FORMAT);
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
		measuredMinWidth = measuredWidth = parent ? parent.width : Values.PT50;
		measuredHeight = Math.max(Math.ceil(tf.textHeight + Values.PT5 + 2 * VPAD), Values.PT40);
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.clear();

		if (hovered) {
			g.beginFill(0xffFFff, 0.25);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}
		else {
			g.beginFill(0xffFFff, 0.00001);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}

		g.beginFill(0x666666, 0.75);
		g.drawRect(HPAD, h - 1, w - 2 * HPAD, 1);
		g.endFill();

		indexTf.text = (itemIndex + 1) + ".";
		indexTf.x = HPAD;
		indexTf.y = h - indexTf.textHeight >> 1;

		tf.x = HPAD + Values.PT30;
		tf.y = h - tf.textHeight >> 1;
		tf.width = w - 2 * HPAD;
		tf.height = h - 2 * VPAD;
		tf.textColor = AppColors.BLACK;
	}

}
}
