package de.dittner.testmyself.ui.common.renderer {
import de.dittner.testmyself.model.domain.theme.Theme;
import de.dittner.testmyself.ui.common.utils.AppColors;
import de.dittner.testmyself.ui.common.utils.FontName;

import flash.display.DisplayObject;
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

	[Embed(source="/assets/button/delete_white_btn.png")]
	private static const DeleteBtnIconClass:Class;

	public function AddedThemeItemRenderer() {
		super();
		percentWidth = 100;
		addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
		mouseChildren = false;
	}

	private var themeName:TextField;
	private var deleteBtnIcon:DisplayObject;

	private function get theme():Theme {
		return data as Theme;
	}

	override protected function createChildren():void {
		super.createChildren();
		themeName = createTextField(SELECTED_THEME_FORMAT);
		//addChild(themeName);

		deleteBtnIcon = new DeleteBtnIconClass();
		//addChild(deleteBtnIcon);
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

	private var matr:Matrix = new Matrix();
	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.clear();

		matr.createGradientBox(w, h, Math.PI / 2);
		g.beginGradientFill(GradientType.LINEAR, AppColors.LIST_ITEM_SELECTION, [1, 1], [0, 255], matr);
		g.drawRect(0, 0, w, h);
		g.endFill();

		themeName.x = themeName.y = PADDING;
		themeName.width = w - 2 * PADDING;
		themeName.height = h - 2 * PADDING;

		deleteBtnIcon.x = w - PADDING - 20;
		deleteBtnIcon.y = (h - 20 >> 1) + 1;
	}

	private function downHandler(event:MouseEvent):void {
		if (event.localX >= deleteBtnIcon.x) {
			if (parent is DataGroup) (parent as DataGroup).dataProvider.removeItemAt(itemIndex);
		}
		else event.stopImmediatePropagation();
	}
}
}
