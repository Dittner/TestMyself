package dittner.testmyself.view.main.components {
import dittner.testmyself.service.screenFactory.ScreenInfo;
import dittner.testmyself.view.common.renderer.ItemRendererBase;
import dittner.testmyself.view.common.utils.AppColors;
import dittner.testmyself.view.common.utils.hideTooltip;
import dittner.testmyself.view.common.utils.showTooltip;

import flash.display.Bitmap;
import flash.display.BlendMode;
import flash.display.Graphics;
import flash.events.MouseEvent;

public class ScreenListItemRenderer extends ItemRendererBase {
	private static const ICON_ALPHA_OUT:Number = 0.5;
	private static const ICON_ALPHA_SELECTED:Number = 0.75;

	private static const VGAP:Number = 20;

	public function ScreenListItemRenderer() {
		super();
	}

	private var icon:Bitmap;

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	private function get screenInfo():ScreenInfo {
		return data as ScreenInfo;
	}

	override public function set data(value:Object):void {
		if (data != value) {
			super.data = value;
			invalidateProperties();
			invalidateSize();
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override protected function createChildren():void {
		super.createChildren();
		icon = new Bitmap();
		icon.alpha = ICON_ALPHA_OUT;
		addChild(icon);
	}

	override protected function commitProperties():void {
		super.commitProperties();
		if (screenInfo) icon.bitmapData = screenInfo.icon;
	}

	override protected function measure():void {
		measuredMinWidth = measuredWidth = icon ? icon.width : 0;
		measuredHeight = measuredMinHeight = icon ? icon.height + VGAP : VGAP;
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.clear();
		g.beginFill(AppColors.BG, selected ? 1 : 0.0001);
		g.drawRect(0, 0, w, h);
		g.endFill();

		icon.alpha = selected ? ICON_ALPHA_SELECTED : ICON_ALPHA_OUT;

		icon.x = (w - icon.width) / 2;
		icon.y = (h - icon.height) / 2;

		icon.blendMode = selected ? BlendMode.INVERT : BlendMode.NORMAL;
	}

	override protected function overHandler(event:MouseEvent):void {
		if (!selected) {
			icon.alpha = 1;
			showTooltip(screenInfo.description, this);
		}
	}

	override protected function outHandler(event:MouseEvent):void {
		if (!selected) {
			icon.alpha = ICON_ALPHA_OUT;
		}
		hideTooltip();
	}
}
}
