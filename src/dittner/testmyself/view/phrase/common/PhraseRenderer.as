package dittner.testmyself.view.phrase.common {
import dittner.testmyself.view.common.renderer.*;
import dittner.testmyself.view.common.utils.AppColors;
import dittner.testmyself.view.common.utils.Fonts;

import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFormat;

public class PhraseRenderer extends ItemRendererBase {
	private static const TITLE_FORMAT:TextFormat = new TextFormat(Fonts.VERDANAMX, 18, AppColors.TEXT_BLACK, true);
	private static const DESCRIPTION_FORMAT:TextFormat = new TextFormat(Fonts.VERDANAMX, 16, AppColors.TEXT_BLACK);

	private static const TEXT_DEFAULT_OFFSET:uint = 2;

	private static const PAD:uint = 20;
	private static const GAP:uint = 10;
	private static const SELECTED_COLOR:uint = AppColors.LIST_LANG_UNIT_SELECTED;

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

	override public function set data(value:Object):void {
		if (phraseData != value) {
			if (phraseData && phraseData.dataChangedCallback == phraseDataChangeHandler)
				phraseData.dataChangedCallback = null;
			super.data = value;
			if (phraseData) phraseData.dataChangedCallback = phraseDataChangeHandler;
		}
	}

	private function phraseDataChangeHandler():void {
		dataChanged = true;
		invalidateProperties();
		invalidateSize();
		invalidateDisplayList();
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
		if (phraseData) {
			titleTf.text = phraseData.transInverted ? phraseData.translation : phraseData.origin;
			descriptionTf.text = phraseData.transInverted ? phraseData.origin : phraseData.translation;
			descriptionTf.visible = phraseData.showDetails || selected;
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
			if (phraseData.horizontalLayout) {
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

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.clear();
		var bgColor:uint = 0;
		var bgAlpha:Number = 1;

		if (selected) {
			bgColor = SELECTED_COLOR;
		}
		else {
			bgColor = 0xffFFff;
			bgAlpha = 0.00001;
		}

		g.beginFill(bgColor, bgAlpha);
		g.drawRect(0, 0, w, h);
		g.endFill();

		g.lineStyle(1, 0xffFFff);
		g.moveTo(PAD / 2, h - 1);
		g.lineTo(w - PAD, h - 1);

		titleTf.x = titleTf.y = PAD - TEXT_DEFAULT_OFFSET;
		if (descriptionTf.visible) {
			descriptionTf.x = (phraseData.horizontalLayout ? (w + GAP) / 2 : PAD) - TEXT_DEFAULT_OFFSET;
			descriptionTf.y = (phraseData.horizontalLayout ? PAD : PAD + titleTf.textHeight + GAP) - TEXT_DEFAULT_OFFSET;

			if (phraseData.horizontalLayout) {
				g.lineStyle(1, 0xffFFff);
				g.moveTo(w / 2 - PAD / 2, 0);
				g.lineTo(w / 2 - PAD / 2, h - 1);
			}
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
