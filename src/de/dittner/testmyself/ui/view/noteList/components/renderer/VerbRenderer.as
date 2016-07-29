package de.dittner.testmyself.ui.view.noteList.components.renderer {
import de.dittner.testmyself.model.domain.note.DeVerb;
import de.dittner.testmyself.ui.common.renderer.*;
import de.dittner.testmyself.ui.common.utils.AppColors;
import de.dittner.testmyself.ui.common.utils.FontName;

import flash.display.GradientType;
import flash.display.Graphics;
import flash.geom.Matrix;
import flash.text.TextField;
import flash.text.TextFormat;

public class VerbRenderer extends ItemRendererBase implements IFlexibleRenderer {
	private static const FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, 18, AppColors.TEXT_BLACK);
	private static const DESCRIPTION_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, 16, AppColors.TEXT_DARK);

	private static const TEXT_DEFAULT_OFFSET:uint = 2;

	private static const HGAP:uint = 5;
	private static const VGAP:uint = 20;
	private static const VPAD:uint = 20;
	private static const HPAD:uint = 20;
	private static const COLOR:uint = AppColors.WHITE;
	private static const SEP_COLOR:uint = 0xc5c5cd;

	public function VerbRenderer() {
		super();
		percentWidth = 100;
	}

	private var infinitiveTf:TextField;
	private var presentTf:TextField;
	private var pastTf:TextField;
	private var perfectTf:TextField;
	private var translationTf:TextField;

	private function get verb():DeVerb {
		return data as DeVerb;
	}

	override protected function createChildren():void {
		super.createChildren();

		translationTf = createMultilineTextField(DESCRIPTION_FORMAT);
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

	public function invalidateLayout():void {}

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

			infinitiveTf.textColor = 0xffFFff;
			presentTf.textColor = 0xffFFff;
			pastTf.textColor = 0xffFFff;
			perfectTf.textColor = 0xffFFff;
			translationTf.textColor = AppColors.DESCRIPTION_SELECTED_TEXT_COLOR;

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

			infinitiveTf.textColor = 0;
			presentTf.textColor = 0;
			pastTf.textColor = 0;
			perfectTf.textColor = 0;
			translationTf.textColor = 0;

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
