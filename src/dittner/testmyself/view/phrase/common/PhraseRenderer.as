package dittner.testmyself.view.phrase.common {
import dittner.testmyself.view.common.renderer.*;
import dittner.testmyself.view.common.utils.AppColors;
import dittner.testmyself.view.common.utils.Fonts;

import flash.display.GradientType;
import flash.display.Graphics;
import flash.geom.Matrix;
import flash.text.TextField;
import flash.text.TextFormat;

public class PhraseRenderer extends ItemRendererBase implements IFlexibleRenderer {
	private static const TITLE_FORMAT:TextFormat = new TextFormat(Fonts.ROBOTO_COND_MX, 24, AppColors.TEXT_BLACK, true);
	private static const DESCRIPTION_FORMAT:TextFormat = new TextFormat(Fonts.ROBOTO_MX, 18, AppColors.TEXT_BLACK);

	private static const TEXT_DEFAULT_OFFSET:uint = 2;

	private static const PAD:uint = 20;
	private static const GAP:uint = 10;
	private static const COLOR:uint = AppColors.WHITE;
	private static const SEP_COLOR:uint = 0xc5c5cd;

	public function PhraseRenderer() {
		super();
		percentWidth = 100;
		minHeight = 50;
	}

	private var titleTf:TextField;
	private var descriptionTf:TextField;

	private function get phraseData():PhraseRendererData {
		return data as PhraseRendererData;
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
		if (phraseData) {
			titleTf.text = phraseData.layout.transInverted ? phraseData.phrase.translation : phraseData.phrase.origin;
			descriptionTf.text = phraseData.layout.transInverted ? phraseData.phrase.origin : phraseData.phrase.translation;
			descriptionTf.visible = phraseData.layout.showDetails || selected;
		}
		else {
			titleTf.text = "";
			descriptionTf.text = "";
			descriptionTf.visible = false;
		}
	}

	override protected function measure():void {
		if (!phraseData || !parent) {
			measuredWidth = measuredHeight = 0;
			return;
		}

		measuredWidth = parent.width;

		if (descriptionTf.visible) {
			if (phraseData.layout.isHorizontal) {
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
			g.moveTo(PAD, h);
			g.lineTo(w - 2 * PAD, h);

			if (phraseData.layout.isHorizontal && descriptionTf.visible) {
				g.moveTo(w / 2, 0);
				g.lineTo(w / 2, h);
			}
		}

		titleTf.textColor = selected ? 0xffFFff : 0;
		titleTf.x = titleTf.y = PAD - TEXT_DEFAULT_OFFSET;

		titleTf.alpha = phraseData.phrase.audioRecord ? 1 : .6;
		if (descriptionTf.visible) {
			descriptionTf.textColor = selected ? 0xffFFff : 0;
			descriptionTf.x = (phraseData.layout.isHorizontal ? (w + GAP) / 2 : PAD) - TEXT_DEFAULT_OFFSET;
			descriptionTf.y = (phraseData.layout.isHorizontal ? PAD : PAD + titleTf.textHeight + GAP) - TEXT_DEFAULT_OFFSET;
			descriptionTf.alpha = phraseData.phrase.audioRecord ? 1 : .6;
		}
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
