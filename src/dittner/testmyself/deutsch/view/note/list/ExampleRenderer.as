package dittner.testmyself.deutsch.view.note.list {
import dittner.testmyself.core.model.note.INote;
import dittner.testmyself.deutsch.view.common.renderer.*;
import dittner.testmyself.deutsch.view.common.utils.AppColors;
import dittner.testmyself.deutsch.view.common.utils.Fonts;

import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFormat;

public class ExampleRenderer extends ItemRendererBase {
	private static const TITLE_FORMAT:TextFormat = new TextFormat(Fonts.ROBOTO_MX, 20, AppColors.TEXT_BLACK);
	private static const DESCRIPTION_FORMAT:TextFormat = new TextFormat(Fonts.ROBOTO_LIGHT_MX, 16, AppColors.TEXT_DARK);

	private static const PAD:uint = 20;
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
			titleTf.text = note.title;
			descriptionTf.text = note.description;
			descriptionTf.visible = selected;
		}
		else {
			titleTf.text = "";
			descriptionTf.text = "";
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

		if (selected) {
			g.beginFill(0xfafaff, 1);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}
		else {
			g.lineStyle(1, SEP_COLOR, 0.5);
			g.moveTo(PAD, h + 1);
			g.lineTo(w - 2 * PAD, h + 1);
		}

		titleTf.x = titleTf.y = PAD;

		titleTf.alpha = hasAudioComment() ? 1 : .7;
		if (descriptionTf.visible) {
			descriptionTf.x = PAD;
			descriptionTf.y = PAD + titleTf.textHeight + GAP;
			descriptionTf.alpha = hasAudioComment() ? 1 : .7;
		}
	}

	private function hasAudioComment():Boolean {
		return note && note.audioComment.bytes;
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
