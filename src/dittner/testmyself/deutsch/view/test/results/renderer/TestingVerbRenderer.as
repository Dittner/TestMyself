package dittner.testmyself.deutsch.view.test.results.renderer {
import dittner.testmyself.core.model.test.ITestTask;
import dittner.testmyself.deutsch.model.domain.verb.IVerb;
import dittner.testmyself.deutsch.view.common.renderer.*;
import dittner.testmyself.deutsch.view.common.utils.AppColors;
import dittner.testmyself.deutsch.view.common.utils.FontName;
import dittner.testmyself.deutsch.view.test.common.TestRendererData;

import flash.display.GradientType;
import flash.display.Graphics;
import flash.geom.Matrix;
import flash.text.TextField;
import flash.text.TextFormat;

public class TestingVerbRenderer extends ItemRendererBase {
	private static const FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, 20, AppColors.WHITE);
	private static const DESCRIPTION_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, 18, AppColors.WHITE);

	private static const TEXT_DEFAULT_OFFSET:uint = 2;

	private static const HGAP:uint = 5;
	private static const VGAP:uint = 20;
	private static const VPAD:uint = 20;
	private static const HPAD:uint = 20;
	private static const COLOR:uint = AppColors.WHITE;
	private static const SEP_COLOR:uint = 0xc5c5cd;

	public function TestingVerbRenderer() {
		super();
		percentWidth = 100;
	}

	private var infinitiveTf:TextField;
	private var presentTf:TextField;
	private var pastTf:TextField;
	private var perfectTf:TextField;
	private var translationTf:TextField;

	private function get renData():TestRendererData {
		return data as TestRendererData;
	}

	private function get verb():IVerb {
		return renData.note as IVerb;
	}

	private function get task():ITestTask {
		return renData.task;
	}

	override protected function createChildren():void {
		super.createChildren();

		translationTf = createMultilineTextField(DESCRIPTION_FORMAT);
		translationTf.alpha = 0.7;
		addChild(translationTf);

		infinitiveTf = createMultilineTextField(FORMAT);
		addChild(infinitiveTf);

		presentTf = createMultilineTextField(FORMAT);
		addChild(presentTf);

		pastTf = createMultilineTextField(FORMAT);
		addChild(pastTf);

		perfectTf = createMultilineTextField(FORMAT);
		addChild(perfectTf);
	}

	override protected function commitProperties():void {
		super.commitProperties();
		if (dataChanged) {
			dataChanged = false;
			updateData();
		}
	}

	private function updateData():void {
		if (verb) {
			infinitiveTf.text = verb.title;
			translationTf.text = verb.description;
			presentTf.text = verb.present;
			pastTf.text = verb.past;
			perfectTf.text = verb.perfect;
		}
		else {
			infinitiveTf.text = "";
			translationTf.text = "";
			presentTf.text = "";
			pastTf.text = "";
			perfectTf.text = "";
		}
	}

	override protected function measure():void {
		if (!verb || !parent) {
			measuredWidth = measuredHeight = 0;
			return;
		}

		measuredWidth = unscaledWidth;

		infinitiveTf.width = measuredWidth / 4 - HPAD - HGAP;
		presentTf.width = measuredWidth / 4 - 2 * HGAP;
		pastTf.width = measuredWidth / 4 - 2 * HGAP;
		perfectTf.width = measuredWidth / 4 - HPAD - HGAP;
		translationTf.width = measuredWidth - 2 * HPAD;

		measuredHeight = Math.max(infinitiveTf.textHeight, presentTf.textHeight, pastTf.textHeight, perfectTf.textHeight) + 2 * VPAD + TEXT_DEFAULT_OFFSET;
		if (selected && translationTf.text) measuredHeight += translationTf.textHeight + VGAP;
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
			matr.createGradientBox(w, h, Math.PI / 2);
			g.beginGradientFill(GradientType.LINEAR, AppColors.LIST_ITEM_SELECTION, [1, 1], [0, 255], matr);
			g.drawRect(0, 0, w, h);
			g.endFill();

			infinitiveTf.textColor = AppColors.WHITE;
			presentTf.visible = true;
			pastTf.visible = true;
			perfectTf.visible = true;
			translationTf.visible = true;
		}
		else {
			g.beginFill(COLOR, 1);
			g.drawRect(0, 0, w, h);
			g.endFill();

			g.lineStyle(1, SEP_COLOR, 0.5);

			g.moveTo(w / 4, 0);
			g.lineTo(w / 4, h - 1);

			g.moveTo(w / 2, 0);
			g.lineTo(w / 2, h - 1);

			g.moveTo(3 * w / 4, 0);
			g.lineTo(3 * w / 4, h - 1);

			g.moveTo(0, h - 1);
			g.lineTo(w, h - 1);

			infinitiveTf.textColor = AppColors.TEXT_BLACK;
			presentTf.visible = false;
			pastTf.visible = false;
			perfectTf.visible = false;
			translationTf.visible = false;
		}

		const WID:Number = w / 4;
		infinitiveTf.x = HPAD;
		infinitiveTf.y = VPAD - TEXT_DEFAULT_OFFSET;
		infinitiveTf.width = WID - infinitiveTf.x - HGAP;
		infinitiveTf.height = infinitiveTf.textHeight + VGAP;

		presentTf.x = w / 4 + HGAP;
		presentTf.y = VPAD - TEXT_DEFAULT_OFFSET;
		presentTf.width = WID - presentTf.x - HGAP;
		presentTf.height = presentTf.textHeight + VGAP;

		pastTf.x = w / 2 + HGAP;
		pastTf.y = VPAD - TEXT_DEFAULT_OFFSET;
		pastTf.width = WID - pastTf.x - HGAP;
		pastTf.height = pastTf.textHeight + VGAP;

		perfectTf.x = 3 / 4 * w + HGAP;
		perfectTf.y = VPAD - TEXT_DEFAULT_OFFSET;
		perfectTf.width = WID - perfectTf.x - HPAD;
		perfectTf.height = perfectTf.textHeight + VGAP;

		if (translationTf.visible) {
			translationTf.x = HPAD;
			translationTf.y = h - translationTf.textHeight - VPAD;
			translationTf.width = w - 2 * HPAD;
			translationTf.height = h - translationTf.y;
		}
	}

	override public function set selected(value:Boolean):void {
		super.selected = value;
		dataChanged = true;
		invalidateSize();
		invalidateDisplayList();
	}

}
}
