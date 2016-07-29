package de.dittner.testmyself.ui.view.test.statistics.renderer {
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.test.TestTask;
import de.dittner.testmyself.ui.common.renderer.*;
import de.dittner.testmyself.ui.common.utils.AppColors;
import de.dittner.testmyself.ui.common.utils.FontName;

import flash.display.GradientType;
import flash.display.Graphics;
import flash.geom.Matrix;
import flash.text.TextField;
import flash.text.TextFormat;

public class TestingNoteRenderer extends NoteBaseRenderer {
	private static const TITLE_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, 28, AppColors.TEXT_BLACK);
	private static const DESCRIPTION_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, 20, AppColors.TEXT_BLACK);

	private static const TEXT_DEFAULT_OFFSET:uint = 2;

	private static const PAD:uint = 20;
	private static const GAP:uint = 10;
	private static const COLOR:uint = AppColors.WHITE;
	private static const SEP_COLOR:uint = 0xc5c5cd;

	public function TestingNoteRenderer() {
		super();
		percentWidth = 100;
		minHeight = 50;
	}

	private var titleTf:TextField;
	private var descriptionTf:TextField;

	private function get task():TestTask {
		return data as TestTask;
	}

	private function get note():Note {
		return task ? task.note : null;
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
			titleTf.htmlText = task.test.needTranslationInvert ? note.description : note.title;
			descriptionTf.htmlText = task.test.needTranslationInvert ? note.title : note.description;
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
			measuredHeight = titleTf.textHeight + descriptionTf.textHeight + 2 * PAD + GAP;
		}
		else {
			titleTf.width = measuredWidth - 2 * PAD;
			measuredHeight = titleTf.textHeight + 2 * PAD;
		}
	}

	private var matr:Matrix = new Matrix();
	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);

		if (w != measuredWidth) {
			invalidateSize();
			invalidateDisplayList();
			return;
		}

		var g:Graphics = graphics;
		g.clear();

		if (selected) {
			matr.createGradientBox(w, h, Math.PI / 2);
			g.beginGradientFill(GradientType.LINEAR, AppColors.LIST_ITEM_SELECTION, [1, 1], [0, 255], matr);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}
		else {
			g.beginFill(COLOR, 1);
			g.drawRect(0, 0, w, h);
			g.endFill();

			g.lineStyle(1, SEP_COLOR, 0.5);
			g.moveTo(PAD, h - 1);
			g.lineTo(w - 2 * PAD, h - 1);
		}

		titleTf.textColor = selected ? 0xffFFff : 0;
		titleTf.x = titleTf.y = PAD - TEXT_DEFAULT_OFFSET;

		if (descriptionTf.visible) {
			descriptionTf.textColor = selected ? AppColors.DESCRIPTION_SELECTED_TEXT_COLOR : 0;
			descriptionTf.x = PAD - TEXT_DEFAULT_OFFSET;
			descriptionTf.y = PAD + titleTf.textHeight + GAP - TEXT_DEFAULT_OFFSET;
		}
	}
}
}
