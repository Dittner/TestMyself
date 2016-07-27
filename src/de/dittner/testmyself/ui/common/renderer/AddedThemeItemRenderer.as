package de.dittner.testmyself.ui.common.renderer {
import de.dittner.testmyself.model.domain.theme.Theme;
import de.dittner.testmyself.ui.common.utils.AppColors;
import de.dittner.testmyself.ui.common.utils.FontName;

import flash.display.BitmapData;
import flash.display.GradientType;
import flash.display.Graphics;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import flash.text.TextField;
import flash.text.TextFormat;

import spark.components.DataGroup;

public class AddedThemeItemRenderer extends ItemRendererBase {
	private static const SELECTED_THEME_FORMAT:TextFormat = new TextFormat(FontName.MYRIAD_MX, 16, AppColors.TEXT_WHITE);
	private static const PADDING:uint = 3;
	private static const RIGHT_PADDING:uint = 5;

	[Embed(source="/assets/button/delete_white_btn.png")]
	private static const DeleteBtnIconClass:Class;
	private static var crossIcon:BitmapData = (new DeleteBtnIconClass()).bitmapData;

	public function AddedThemeItemRenderer() {
		super();
		percentWidth = 100;
		addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
		mouseChildren = false;
	}

	private var themeName:TextField;

	private function get theme():Theme {
		return data as Theme;
	}

	override protected function createChildren():void {
		super.createChildren();
		themeName = createTextField(SELECTED_THEME_FORMAT);
		addChild(themeName);
	}

	override protected function commitProperties():void {
		super.commitProperties();
		if (dataChanged) {
			dataChanged = false;
			themeName.text = theme ? theme.name : "";
		}
	}

	override protected function measure():void {
		measuredMinWidth = measuredWidth = parent ? parent.width : 50;
		minHeight = 10;
		measuredHeight = themeName.textHeight + 5 + 2 * PADDING;
	}

	private var gradMatrix:Matrix = new Matrix();
	private var iconDrawMatrix:Matrix = new Matrix();
	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.clear();

		gradMatrix.createGradientBox(w, h, Math.PI / 2);
		g.beginGradientFill(GradientType.LINEAR, AppColors.LIST_ITEM_SELECTION, [1, 1], [0, 255], gradMatrix);
		g.drawRect(0, 0, w, h);
		g.endFill();

		iconDrawMatrix.tx = w - crossIcon.width - RIGHT_PADDING;
		iconDrawMatrix.ty = h - crossIcon.height >> 1;
		g.beginBitmapFill(crossIcon, iconDrawMatrix);
		g.drawRect(w - crossIcon.width - RIGHT_PADDING, h - crossIcon.height >> 1, crossIcon.width, crossIcon.height);
		g.endFill();

		themeName.x = themeName.y = PADDING;
		themeName.width = w - 2 * PADDING;
		themeName.height = h - 2 * PADDING;
	}

	private function downHandler(event:MouseEvent):void {
		if (event.localX >= measuredWidth - crossIcon.width - RIGHT_PADDING) {
			if (theme && parent is DataGroup) (parent as DataGroup).dataProvider.removeItemAt(itemIndex);
		}
		else event.stopImmediatePropagation();
	}

}
}
