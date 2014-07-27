package dittner.testmyself.view.common.renderer {
import dittner.testmyself.service.helpers.toolFactory.ToolInfo;
import dittner.testmyself.view.common.tooltip.ManualToolTipManager;
import dittner.testmyself.view.common.tooltip.ToolTipPos;

import flash.display.Bitmap;
import flash.display.BlendMode;
import flash.events.MouseEvent;
import flash.geom.Point;

public class ToolItemRenderer extends ItemRendererBase {
	private static const ICON_ALPHA_OUT:Number = 0.5;
	private static const ICON_ALPHA_SELECTED:Number = 0.75;

	public function ToolItemRenderer() {
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

	private function get toolInfo():ToolInfo {
		return data as ToolInfo;
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
		if (toolInfo) icon.bitmapData = toolInfo.icon;
	}

	override protected function measure():void {
		measuredMinWidth = measuredWidth = icon ? icon.width : 0;
		measuredHeight = measuredMinHeight = icon ? icon.height : 0;
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		icon.alpha = selected ? ICON_ALPHA_SELECTED : ICON_ALPHA_OUT;

		icon.x = (w - icon.width) / 2;
		icon.y = (h - icon.height) / 2;

		icon.blendMode = selected ? BlendMode.INVERT : BlendMode.NORMAL;
	}

	private function overHandler(event:MouseEvent):void {
		if (!selected) {
			icon.alpha = 1;
			var topLeftPoint:Point = this.localToGlobal(new Point(0, 0));
			ManualToolTipManager.show(toolInfo.description, topLeftPoint.x + getExplicitOrMeasuredWidth() / 2, topLeftPoint.y + getExplicitOrMeasuredHeight(), ToolTipPos.TOP);
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