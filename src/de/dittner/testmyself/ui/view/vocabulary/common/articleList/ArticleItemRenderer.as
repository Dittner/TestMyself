package de.dittner.testmyself.ui.view.vocabulary.common.articleList {
import de.dittner.testmyself.ui.common.renderer.*;
import de.dittner.testmyself.ui.common.utils.AppColors;
import de.dittner.testmyself.ui.common.utils.FontName;

import flash.display.GradientType;
import flash.display.Graphics;
import flash.geom.Matrix;
import flash.text.TextField;
import flash.text.TextFormat;

public class ArticleItemRenderer extends ItemRendererBase {
	private static const THEME_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, 18, AppColors.TEXT_GRAY);
	private static const SELECTED_THEME_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, 18, AppColors.TEXT_WHITE);
	private static const PADDING:uint = 3;
	private static const HOVER_COLOR:uint = AppColors.LIST_ITEM_HOVER;
	private static const REN_HEI:uint = 35;

	public function ArticleItemRenderer() {
		super();
		percentWidth = 100;
	}

	private var articleTF:TextField;

	override protected function createChildren():void {
		super.createChildren();
		articleTF = createTextField(THEME_FORMAT);
		addChild(articleTF);
	}

	override protected function commitProperties():void {
		super.commitProperties();
		if (dataChanged) {
			dataChanged = false;
			articleTF.text = data is String ? data as String : "";
		}
	}

	override protected function measure():void {
		measuredMinWidth = measuredWidth = parent ? parent.width : 50;
		measuredHeight = REN_HEI;
	}

	private var matr:Matrix = new Matrix();
	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.clear();

		if (selected) {
			articleTF.setTextFormat(SELECTED_THEME_FORMAT);

			matr.createGradientBox(w, h, Math.PI / 2);
			g.beginGradientFill(GradientType.LINEAR, AppColors.LIST_ITEM_SELECTION, [1, 1], [0, 255], matr);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}
		else if (hovered) {
			articleTF.setTextFormat(THEME_FORMAT);

			g.beginFill(HOVER_COLOR, 1);
			g.drawRect(0, 0, w, h);
			g.endFill();

			g.lineStyle(1, 0xccCCcc, .75);
			g.moveTo(0, h - 1);
			g.lineTo(w, h - 1);
		}
		else {
			articleTF.setTextFormat(THEME_FORMAT);

			g.beginFill(0xffFFff, 0.00001);
			g.drawRect(0, 0, w, h);
			g.endFill();

			g.lineStyle(1, 0xccCCcc, .75);
			g.moveTo(0, h - 1);
			g.lineTo(w, h - 1);
		}

		articleTF.x = PADDING;
		articleTF.y = h - articleTF.textHeight >> 1;
		articleTF.width = w - 2 * PADDING;
		articleTF.height = h - 2 * PADDING;
	}

}
}
