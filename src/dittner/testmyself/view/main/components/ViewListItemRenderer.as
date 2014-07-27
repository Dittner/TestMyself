package dittner.testmyself.view.main.components {
import dittner.testmyself.service.helpers.viewFactory.ViewInfo;
import dittner.testmyself.view.common.renderer.ItemRendererBase;
import dittner.testmyself.view.common.tooltip.ManualToolTipManager;
import dittner.testmyself.view.common.tooltip.ToolTipPos;
import dittner.testmyself.view.utils.AppColors;

import flash.display.Bitmap;
import flash.display.BlendMode;
import flash.display.Graphics;
import flash.events.MouseEvent;
import flash.geom.Point;

public class ViewListItemRenderer extends ItemRendererBase {
	private static const ICON_ALPHA_OUT:Number = 0.5;
	private static const ICON_ALPHA_SELECTED:Number = 0.75;

	private static const VGAP:Number = 20;

	public function ViewListItemRenderer() {
		super();
		addEventListener(MouseEvent.MOUSE_OVER, overHandler);
		addEventListener(MouseEvent.MOUSE_OUT, outHandler);
	}

	private var icon:Bitmap;

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	private function get viewInfo():ViewInfo {
		return data as ViewInfo;
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
		if (viewInfo) icon.bitmapData = viewInfo.icon;
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

	private function overHandler(event:MouseEvent):void {
		if (!selected) {
			icon.alpha = 1;
			var topLeftPoint:Point = this.localToGlobal(new Point(0, 0));
			ManualToolTipManager.show(viewInfo.description, topLeftPoint.x + getExplicitOrMeasuredWidth() + 10, topLeftPoint.y + getExplicitOrMeasuredHeight() / 2, ToolTipPos.LEFT);
		}
	}

	private function outHandler(event:MouseEvent):void {
		if (!selected) {
			icon.alpha = ICON_ALPHA_OUT;
		}
		ManualToolTipManager.hide();
	}
}
}
