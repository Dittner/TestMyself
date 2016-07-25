package de.dittner.testmyself.ui.view.vocabulary.note.list {
import de.dittner.testmyself.model.domain.note.INote;
import de.dittner.testmyself.ui.common.renderer.*;
import de.dittner.testmyself.ui.common.utils.AppColors;
import de.dittner.testmyself.ui.common.utils.FontName;

import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFormat;

public class ExampleRenderer extends NoteBaseRenderer {
	private static const TITLE_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, 22, AppColors.TEXT_BLACK);
	private static const DESCRIPTION_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, 18, AppColors.TEXT_DARK);

	private static const PAD:uint = 15;
	private static const GAP:uint = 10;
	private static const SEP_COLOR:uint = 0xaaAAaa;

	public function ExampleRenderer() {
		super();
		percentWidth = 100;
		minHeight = 30;
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
			titleTf.htmlText = note.title;
			descriptionTf.htmlText = note.description;
			descriptionTf.visible = selected;
		}
		else {
			titleTf.htmlText = "";
			descriptionTf.htmlText = "";
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

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.clear();

		if (w != measuredWidth) {
			invalidateSize();
			invalidateDisplayList();
			return;
		}

		updateSoundIconPos(w, h);

		if (selected) {
			g.beginFill(0xfafaff, 1);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}
		else {
			g.lineStyle(1, SEP_COLOR, 0.5);
			g.moveTo(PAD, h - 1);
			g.lineTo(w - 2 * PAD, h - 1);
		}

		titleTf.x = titleTf.y = PAD;

		if (descriptionTf.visible) {
			descriptionTf.x = PAD;
			descriptionTf.y = PAD + titleTf.textHeight + GAP;
		}
	}

}
}
