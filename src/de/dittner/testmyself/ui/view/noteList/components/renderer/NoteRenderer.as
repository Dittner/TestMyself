package de.dittner.testmyself.ui.view.noteList.components.renderer {
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.ui.common.renderer.*;
import de.dittner.testmyself.ui.common.utils.AppColors;
import de.dittner.testmyself.ui.common.utils.FontName;
import de.dittner.testmyself.ui.view.noteList.components.NoteList;
import de.dittner.testmyself.ui.view.noteList.components.PageLayout;

import flash.display.GradientType;
import flash.display.Graphics;
import flash.geom.Matrix;
import flash.text.TextField;
import flash.text.TextFormat;

public class NoteRenderer extends NoteBaseRenderer implements IFlexibleRenderer {
	private static const TITLE_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, 26, AppColors.TEXT_BLACK, true);
	private static const DESCRIPTION_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, 20, AppColors.TEXT_BLACK);

	private static const TEXT_DEFAULT_OFFSET:uint = 2;

	private static const PAD:uint = 20;
	private static const GAP:uint = 10;
	private static const COLOR:uint = AppColors.WHITE;
	private static const SEP_COLOR:uint = 0xc5c5cd;

	public function NoteRenderer() {
		super();
		percentWidth = 100;
		minHeight = 50;
	}

	private var titleTf:TextField;
	private var descriptionTf:TextField;

	private function get note():Note {
		return data as Note;
	}

	private function get pageLayout():PageLayout {
		return parent is NoteList ? (parent as NoteList).pageLayout : null;
	}

	override protected function createChildren():void {
		super.createChildren();
		descriptionTf = createMultilineTextField(DESCRIPTION_FORMAT);
		addChild(descriptionTf);
		titleTf = createMultilineTextField(TITLE_FORMAT);
		addChild(titleTf);
	}

	public function invalidateLayout():void {
		dataChanged = true;
		invalidateProperties();
		invalidateSize();
		invalidateDisplayList();
	}

	override protected function commitProperties():void {
		super.commitProperties();
		if (dataChanged) {
			dataChanged = false;
			updateData();
		}
	}

	private function updateData():void {
		if (note && pageLayout) {
			titleTf.htmlText = pageLayout.inverted ? note.description : note.title;
			descriptionTf.htmlText = pageLayout.inverted ? note.title : note.description;
			descriptionTf.visible = pageLayout.showDetails || selected;
		}
		else {
			titleTf.htmlText = "";
			descriptionTf.htmlText = "";
			descriptionTf.visible = false;
		}
	}

	override protected function measure():void {
		if (!note || !pageLayout || !parent) {
			measuredWidth = measuredHeight = 0;
			return;
		}

		measuredWidth = parent.width;

		if (descriptionTf.visible) {
			if (pageLayout.isHorizontal) {
				titleTf.width = descriptionTf.width = (measuredWidth - 2 * PAD - GAP) / 2;
				measuredHeight = Math.max(titleTf.textHeight, descriptionTf.textHeight) + 2 * PAD;
			}
			else {
				titleTf.width = descriptionTf.width = measuredWidth - 2 * PAD;
				measuredHeight = titleTf.textHeight + descriptionTf.textHeight + 2 * PAD + GAP;
			}
		}
		else {
			titleTf.width = measuredWidth - 2 * PAD;
			measuredHeight = titleTf.textHeight + 2 * PAD;
		}
	}

	private var mtr:Matrix = new Matrix();
	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.clear();

		updateSoundIconPos(w, h);

		if (selected) {
			mtr.createGradientBox(w, h, Math.PI / 2);
			g.beginGradientFill(GradientType.LINEAR, AppColors.LIST_ITEM_SELECTION, [1, 1], [0, 255], mtr);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}
		else {
			g.lineStyle(1, SEP_COLOR, 0.5);
			g.moveTo(PAD, h - 1);
			g.lineTo(w - 2 * PAD, h - 1);

			if (pageLayout.isHorizontal && descriptionTf.visible) {
				g.moveTo(w / 2, 0);
				g.lineTo(w / 2, h - 1);
			}
		}

		titleTf.textColor = selected ? 0xffFFff : 0;
		titleTf.x = titleTf.y = PAD - TEXT_DEFAULT_OFFSET;

		if (descriptionTf.visible) {
			descriptionTf.textColor = selected ? AppColors.DESCRIPTION_SELECTED_TEXT_COLOR : 0;
			descriptionTf.x = (pageLayout.isHorizontal ? (w + GAP) / 2 : PAD) - TEXT_DEFAULT_OFFSET;
			descriptionTf.y = (pageLayout.isHorizontal ? PAD : PAD + titleTf.textHeight + GAP) - TEXT_DEFAULT_OFFSET;
		}
	}

}
}
