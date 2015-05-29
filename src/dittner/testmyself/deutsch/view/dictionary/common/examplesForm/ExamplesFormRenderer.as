package dittner.testmyself.deutsch.view.dictionary.common.examplesForm {
import dittner.testmyself.core.model.note.INote;
import dittner.testmyself.deutsch.view.common.renderer.*;
import dittner.testmyself.deutsch.view.common.utils.AppColors;
import dittner.testmyself.deutsch.view.common.utils.Fonts;

import flash.display.GradientType;
import flash.display.Graphics;
import flash.geom.Matrix;
import flash.text.TextField;
import flash.text.TextFormat;

public class ExamplesFormRenderer extends NoteBaseRenderer {
	private static const TITLE_FORMAT:TextFormat = new TextFormat(Fonts.MYRIAD_MX, 18, AppColors.TEXT_BLACK);
	private static const DESCRIPTION_FORMAT:TextFormat = new TextFormat(Fonts.MYRIAD_MX, 18, AppColors.TEXT_GRAY, null, true);

	private static const PAD:uint = 3;
	private static const GAP:uint = 3;
	private static const SEP_COLOR:uint = 0xccCCcc;

	public function ExamplesFormRenderer() {
		super();
		percentWidth = 100;
	}

	private var titleTf:TextField;
	private var descriptionTf:TextField;

	private function get note():INote {
		return data as INote;
	}

	override protected function createChildren():void {
		super.createChildren();
		descriptionTf = createMultilineTextField(DESCRIPTION_FORMAT);
		addChild(descriptionTf);
		titleTf = createMultilineTextField(TITLE_FORMAT);
		addChild(titleTf);
	}

	override protected function commitProperties():void {
		super.commitProperties();
		if (dataChanged) {
			dataChanged = false;
			updateData();
		}
	}

	private function updateData():void {
		if (note) {
			titleTf.text = note.title;
			descriptionTf.text = note.description;
			descriptionTf.visible = selected;
		}
		else {
			titleTf.text = "";
			descriptionTf.text = "";
			descriptionTf.visible = false;
		}
	}

	override protected function measure():void {
		if (!note || !parent) {
			measuredWidth = measuredHeight = 0;
			return;
		}

		measuredWidth = parent.width;

		if (descriptionTf.visible) {
			titleTf.width = descriptionTf.width = measuredWidth - 2 * PAD;
			measuredHeight = titleTf.textHeight + descriptionTf.textHeight + 2 * PAD + GAP + 4;
		}
		else {
			titleTf.width = measuredWidth - 2 * PAD;
			measuredHeight = titleTf.textHeight + 2 * PAD + 2;
		}
	}

	private var matr:Matrix = new Matrix();
	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.clear();

		if (selected) {
			matr.createGradientBox(w, h, Math.PI / 2);
			g.beginGradientFill(GradientType.LINEAR, AppColors.LIST_ITEM_SELECTION, [1, 1], [0, 255], matr);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}
		else {
			if (!hasAudioComment()) showNoAudioNotification();
			g.lineStyle(1, SEP_COLOR, 0.75);
			g.moveTo(0, h - 1);
			g.lineTo(w, h - 1);
		}

		titleTf.textColor = selected ? 0xffFFff : 0;
		titleTf.x = titleTf.y = PAD;

		if (descriptionTf.visible) {
			descriptionTf.textColor = selected ? 0xffFFff : 0;
			descriptionTf.x = PAD;
			descriptionTf.y = PAD + titleTf.textHeight + GAP;
		}
	}

}
}
