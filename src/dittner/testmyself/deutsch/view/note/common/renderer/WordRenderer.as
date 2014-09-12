package dittner.testmyself.deutsch.view.note.common.renderer {
import dittner.testmyself.deutsch.model.word.IWord;
import dittner.testmyself.deutsch.model.word.WordArticle;
import dittner.testmyself.deutsch.view.common.renderer.*;
import dittner.testmyself.deutsch.view.common.utils.AppColors;
import dittner.testmyself.deutsch.view.common.utils.Fonts;

import flash.display.GradientType;
import flash.display.Graphics;
import flash.geom.Matrix;
import flash.text.TextField;
import flash.text.TextFormat;

public class WordRenderer extends ItemRendererBase implements IFlexibleRenderer {
	private static const TITLE_FORMAT:TextFormat = new TextFormat(Fonts.ROBOTO_COND_MX, 24, AppColors.TEXT_BLACK, true);
	private static const DIE_FORMAT:TextFormat = new TextFormat(Fonts.ROBOTO_COND_MX, 24, AppColors.TEXT_RED, true);
	private static const DAS_FORMAT:TextFormat = new TextFormat(Fonts.ROBOTO_COND_MX, 24, AppColors.TEXT_YELLOW, true);
	private static const DESCRIPTION_FORMAT:TextFormat = new TextFormat(Fonts.ROBOTO_MX, 18, AppColors.TEXT_BLACK);

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

	private function get noteData():NoteRendererData {
		return data as NoteRendererData;
	}

	private function get word():IWord {
		return noteData.note as IWord;
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
		if (word) {
			var description:String = word.description;
			var title:String = "";
			if (word.article) title = word.article + " ";
			title += word.title;
			if (word.options && (selected || noteData.layout.showDetails))
				title += ", " + word.options;

			if (noteData.layout.inverted) {
				titleTf.text = description;
				descriptionTf.text = title;
				titleTf.setTextFormat(TITLE_FORMAT);
				descriptionTf.setTextFormat(DESCRIPTION_FORMAT);
				titleTf.textColor = selected ? 0xffFFff : 0;
			}
			else {
				titleTf.text = title;
				descriptionTf.text = description;
				titleTf.setTextFormat(TITLE_FORMAT);
				titleTf.textColor = selected ? 0xffFFff : 0;
				descriptionTf.setTextFormat(DESCRIPTION_FORMAT);
				switch (word.article) {
					case WordArticle.DIE :
						titleTf.setTextFormat(DIE_FORMAT, 0, word.article.length);
						break;
					case WordArticle.DAS :
						titleTf.setTextFormat(DAS_FORMAT, 0, word.article.length);
						break;
					case WordArticle.DER_DIE :
						titleTf.setTextFormat(DIE_FORMAT, 4, word.article.length);
						break;
				}
			}

			descriptionTf.visible = noteData.layout.showDetails || selected;
		}
		else {
			titleTf.text = "";
			descriptionTf.text = "";
			descriptionTf.visible = false;
		}
	}

	override protected function measure():void {
		if (!noteData || !parent) {
			measuredWidth = measuredHeight = 0;
			return;
		}

		measuredWidth = unscaledWidth;

		if (descriptionTf.visible) {
			if (noteData.layout.isHorizontal) {
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

		if (selected) {
			matr.createGradientBox(w, h, 90);
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

			if (noteData.layout.isHorizontal && descriptionTf.visible) {
				g.moveTo(w / 2, 0);
				g.lineTo(w / 2, h - 1);
			}
		}

		titleTf.x = titleTf.y = PAD - TEXT_DEFAULT_OFFSET;

		titleTf.alpha = hasAudioComment() ? 1 : .7;
		if (descriptionTf.visible) {
			descriptionTf.textColor = selected ? 0xffFFff : 0;
			descriptionTf.x = (noteData.layout.isHorizontal ? (w + GAP) / 2 : PAD) - TEXT_DEFAULT_OFFSET;
			descriptionTf.y = (noteData.layout.isHorizontal ? PAD : PAD + titleTf.textHeight + GAP) - TEXT_DEFAULT_OFFSET;
			descriptionTf.alpha = hasAudioComment() ? 1 : .7;
		}
	}

	private function hasAudioComment():Boolean {
		return noteData && noteData.note.audioComment.bytes;
	}

	override public function set selected(value:Boolean):void {
		super.selected = value;
		dataChanged = true;
		invalidateProperties();
		invalidateSize();
		invalidateDisplayList();
	}

}
}
