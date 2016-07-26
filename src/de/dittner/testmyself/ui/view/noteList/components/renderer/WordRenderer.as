package de.dittner.testmyself.ui.view.noteList.components.renderer {
import de.dittner.testmyself.model.domain.note.word.DeWord;
import de.dittner.testmyself.model.domain.note.word.DeWordArticle;
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

public class WordRenderer extends NoteBaseRenderer implements IFlexibleRenderer {
	private static const TITLE_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, 26, AppColors.TEXT_BLACK, true);
	private static const DIE_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, 26, AppColors.TEXT_RED, true);
	private static const DAS_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, 26, AppColors.TEXT_YELLOW, true);
	private static const DESCRIPTION_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, 20, AppColors.TEXT_BLACK);

	private static const TEXT_DEFAULT_OFFSET:uint = 2;

	private static const PAD:uint = 20;
	private static const GAP:uint = 10;
	private static const COLOR:uint = AppColors.WHITE;
	private static const SEP_COLOR:uint = 0xc5c5cd;

	public function WordRenderer() {
		super();
		percentWidth = 100;
		minHeight = 50;
	}

	private var titleTf:TextField;
	private var descriptionTf:TextField;

	private function get word():DeWord {
		return data as DeWord;
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
		if (word && pageLayout) {
			var description:String = word.description;
			var title:String = "";
			if (word.article) title = word.article + " ";
			title += word.title;
			if (word.options && (selected || pageLayout.showDetails))
				title += ", " + word.options;

			if (pageLayout.inverted) {
				titleTf.htmlText = description;
				descriptionTf.htmlText = title;
				titleTf.setTextFormat(TITLE_FORMAT);
				descriptionTf.setTextFormat(DESCRIPTION_FORMAT);
				titleTf.textColor = selected ? 0xffFFff : 0;
			}
			else {
				titleTf.htmlText = title;
				descriptionTf.htmlText = description;
				titleTf.setTextFormat(TITLE_FORMAT);
				titleTf.textColor = selected ? 0xffFFff : 0;
				descriptionTf.setTextFormat(DESCRIPTION_FORMAT);
				switch (word.article) {
					case DeWordArticle.DIE :
						titleTf.setTextFormat(DIE_FORMAT, 0, word.article.length);
						break;
					case DeWordArticle.DAS :
						titleTf.setTextFormat(DAS_FORMAT, 0, word.article.length);
						break;
					case DeWordArticle.DER_DIE :
						titleTf.setTextFormat(DIE_FORMAT, 4, word.article.length);
						break;
					case DeWordArticle.DER_DAS :
						titleTf.setTextFormat(DAS_FORMAT, 4, word.article.length);
						break;
					case DeWordArticle.DIE_DAS :
						titleTf.setTextFormat(DIE_FORMAT, 0, 4);
						titleTf.setTextFormat(DAS_FORMAT, 4, word.article.length);
						break;
					case DeWordArticle.DER_DIE_DAS :
						titleTf.setTextFormat(DIE_FORMAT, 4, word.article.length);
						titleTf.setTextFormat(DAS_FORMAT, 8, word.article.length);
						break;
				}
			}

			descriptionTf.visible = pageLayout.showDetails || selected;
		}
		else {
			titleTf.htmlText = "";
			descriptionTf.htmlText = "";
			descriptionTf.visible = false;
		}
	}

	override protected function measure():void {
		if (!word || !pageLayout || !parent) {
			measuredWidth = measuredHeight = 0;
			return;
		}

		measuredWidth = unscaledWidth;

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

	private var matr:Matrix = new Matrix();
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
			matr.createGradientBox(w, h, Math.PI / 2);
			g.beginGradientFill(GradientType.LINEAR, AppColors.LIST_ITEM_SELECTION, [1, 1], [0, 255], matr);
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

		titleTf.x = titleTf.y = PAD - TEXT_DEFAULT_OFFSET;

		if (descriptionTf.visible) {
			descriptionTf.textColor = selected ? AppColors.DESCRIPTION_SELECTED_TEXT_COLOR : 0;
			descriptionTf.x = (pageLayout.isHorizontal ? (w + GAP) / 2 : PAD) - TEXT_DEFAULT_OFFSET;
			descriptionTf.y = (pageLayout.isHorizontal ? PAD : PAD + titleTf.textHeight + GAP) - TEXT_DEFAULT_OFFSET;
		}
	}

}
}
