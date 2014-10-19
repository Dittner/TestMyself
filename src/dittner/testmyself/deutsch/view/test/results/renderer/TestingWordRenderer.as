package dittner.testmyself.deutsch.view.test.results.renderer {
import dittner.testmyself.core.model.test.ITestTask;
import dittner.testmyself.deutsch.model.domain.word.IWord;
import dittner.testmyself.deutsch.model.domain.word.WordArticle;
import dittner.testmyself.deutsch.view.common.renderer.*;
import dittner.testmyself.deutsch.view.common.utils.AppColors;
import dittner.testmyself.deutsch.view.common.utils.Fonts;
import dittner.testmyself.deutsch.view.test.common.TestRendererData;
import dittner.testmyself.deutsch.view.test.results.TestTaskCard;

import flash.display.GradientType;
import flash.display.Graphics;
import flash.geom.Matrix;
import flash.text.TextField;
import flash.text.TextFormat;

public class TestingWordRenderer extends ItemRendererBase {
	private static const TITLE_FORMAT:TextFormat = new TextFormat(Fonts.ROBOTO_COND_MX, 24, AppColors.TEXT_BLACK);
	private static const DIE_FORMAT:TextFormat = new TextFormat(Fonts.ROBOTO_COND_MX, 24, AppColors.TEXT_RED);
	private static const DAS_FORMAT:TextFormat = new TextFormat(Fonts.ROBOTO_COND_MX, 24, AppColors.TEXT_YELLOW);
	private static const DESCRIPTION_FORMAT:TextFormat = new TextFormat(Fonts.ROBOTO_MX, 18, AppColors.TEXT_BLACK);

	private static const TEXT_DEFAULT_OFFSET:uint = 2;

	private static const PAD:uint = 20;
	private static const GAP:uint = 10;
	private static const COLOR:uint = AppColors.WHITE;
	private static const SEP_COLOR:uint = 0xc5c5cd;

	public function TestingWordRenderer() {
		super();
		percentWidth = 100;
		minHeight = 50;
	}

	private var titleTf:TextField;
	private var descriptionTf:TextField;
	private var testTaskCard:TestTaskCard;

	private function get renData():TestRendererData {
		return data as TestRendererData;
	}

	private function get word():IWord {
		return renData.note as IWord;
	}

	private function get task():ITestTask {
		return renData.task;
	}

	override protected function createChildren():void {
		super.createChildren();
		descriptionTf = createMultilineTextField(DESCRIPTION_FORMAT);
		addChild(descriptionTf);
		titleTf = createMultilineTextField(TITLE_FORMAT);
		addChild(titleTf);
		testTaskCard = new TestTaskCard();
		addChild(testTaskCard);
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
			if (word.options && selected)
				title += ", " + word.options;

			titleTf.text = title;
			descriptionTf.text = description;
			titleTf.setTextFormat(TITLE_FORMAT);
			titleTf.textColor = selected ? 0xffFFff : 0;
			descriptionTf.setTextFormat(DESCRIPTION_FORMAT);
			var negativeAnswerNum:uint = (task.amount - task.balance) / 2;
			testTaskCard.label = negativeAnswerNum + " / " + task.amount;
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

			descriptionTf.visible = selected;
		}
		else {
			titleTf.text = "";
			descriptionTf.text = "";
			descriptionTf.visible = false;
		}
	}

	override protected function measure():void {
		if (!renData || !parent) {
			measuredWidth = measuredHeight = 0;
			return;
		}

		measuredWidth = unscaledWidth;

		if (descriptionTf.visible) {
			if (renData) {
				titleTf.width = descriptionTf.width = (measuredWidth - 2 * PAD - GAP) / 2;
				measuredHeight = Math.max(titleTf.textHeight, descriptionTf.textHeight) + 2 * PAD;
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

			if (descriptionTf.visible) {
				g.moveTo(w / 2, 0);
				g.lineTo(w / 2, h - 1);
			}
		}

		titleTf.x = titleTf.y = PAD - TEXT_DEFAULT_OFFSET;

		titleTf.alpha = hasAudioComment() ? 1 : .7;
		if (descriptionTf.visible) {
			descriptionTf.textColor = selected ? 0xffFFff : 0;
			descriptionTf.x = (w + GAP) / 2 - TEXT_DEFAULT_OFFSET;
			descriptionTf.y = PAD - TEXT_DEFAULT_OFFSET;
			descriptionTf.alpha = hasAudioComment() ? 1 : .7;
		}

		testTaskCard.x = w - testTaskCard.width - PAD;
		testTaskCard.y = 5;
	}

	private function hasAudioComment():Boolean {
		return renData && renData.note.audioComment.bytes;
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
