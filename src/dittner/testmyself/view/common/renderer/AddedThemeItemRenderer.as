package dittner.testmyself.view.common.renderer {
import dittner.testmyself.model.theme.ITheme;
import dittner.testmyself.view.common.utils.AppColors;
import dittner.testmyself.view.common.utils.Fonts;

import flash.display.Graphics;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;

import mx.core.UIComponent;

import spark.components.DataGroup;

public class AddedThemeItemRenderer extends ItemRendererBase {
	private static const SELECTED_THEME_FORMAT:TextFormat = new TextFormat(Fonts.ROBOTO_MX, 14, AppColors.TEXT_WHITE);
	private static const PADDING:uint = 3;
	private static const SELECTED_COLOR:uint = AppColors.LIST_ITEM_SELECTION;

	[Embed(source="/assets/button/delete_white_btn.png")]
	private static const DeleteBtnIconClass:Class;

	public function AddedThemeItemRenderer() {
		super();
		percentWidth = 100;
		addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
	}

	private var themeName:TextField;
	private var deleteBtnIcon:UIComponent;

	private function get theme():ITheme {
		return data as ITheme;
	}

	override protected function createChildren():void {
		super.createChildren();
		themeName = createTextField(SELECTED_THEME_FORMAT);
		addChild(themeName);

		deleteBtnIcon = new UIComponent();
		deleteBtnIcon.addChild(new DeleteBtnIconClass());
		deleteBtnIcon.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);

		addChild(deleteBtnIcon);
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

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.clear();

		g.beginFill(SELECTED_COLOR, 1);
		g.drawRect(0, 0, w, h);
		g.endFill();

		g.lineStyle(1, 0x555555);
		g.moveTo(0, h - 1);
		g.lineTo(w, h - 1);

		themeName.x = themeName.y = PADDING;
		themeName.width = w - 2 * PADDING;
		themeName.height = h - 2 * PADDING;

		deleteBtnIcon.x = w - PADDING - 20;
		deleteBtnIcon.y = (h - 20 >> 1) + 1;
	}

	private function downHandler(event:MouseEvent):void {
		if (event.currentTarget == deleteBtnIcon) {
			if (parent is DataGroup) (parent as DataGroup).dataProvider.removeItemAt(itemIndex);
		}
		else event.stopImmediatePropagation();
	}
}
}
