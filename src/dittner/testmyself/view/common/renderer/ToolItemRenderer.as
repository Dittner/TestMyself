package dittner.testmyself.view.common.renderer {
import dittner.testmyself.service.helpers.toolFactory.ToolInfo;
import dittner.testmyself.view.common.tooltip.ManualToolTipManager;
import dittner.testmyself.view.common.tooltip.ToolTipPos;

import flash.display.Bitmap;
import flash.display.BlendMode;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

public class ToolItemRenderer extends ItemRendererBase {
	private static const ICON_ALPHA_OUT:Number = 0.75;
	private static const ICON_ALPHA_HOVER:Number = 1;
	private static const ICON_ALPHA_SELECTED:Number = 1;
	private static const ICON_ALPHA_INACTIVE:Number = 0.25;

	public function ToolItemRenderer() {
		super();
		addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
		addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
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
			if (toolInfo) toolInfo.removeEventListener(ToolInfo.ACTIVE_CHANGED_EVENT, toolInfoActiveChanged);
			super.data = value;
			if (toolInfo) toolInfo.addEventListener(ToolInfo.ACTIVE_CHANGED_EVENT, toolInfoActiveChanged);
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
		icon.x = (w - icon.width) / 2;
		icon.y = (h - icon.height) / 2;

		updateState();
	}

	private function updateState():void {
		if (toolInfo.active) {
			if (selected) {
				icon.alpha = ICON_ALPHA_SELECTED;
				icon.blendMode = BlendMode.INVERT;
			}
			else if (hovered) {
				icon.alpha = ICON_ALPHA_HOVER;
				icon.blendMode = BlendMode.NORMAL;
			}
			else {
				icon.alpha = ICON_ALPHA_OUT;
				icon.blendMode = BlendMode.NORMAL;
			}
			mouseEnabled = mouseChildren = true;
		}
		else {
			icon.alpha = ICON_ALPHA_INACTIVE;
			icon.blendMode = BlendMode.NORMAL;
			mouseEnabled = mouseChildren = false;
		}
	}

	private var hovered:Boolean = false;
	private function mouseOverHandler(event:MouseEvent):void {
		hovered = true;
		if (!selected) {
			var topLeftPoint:Point = this.localToGlobal(new Point(0, 0));
			ManualToolTipManager.show(toolInfo.description, topLeftPoint.x + getExplicitOrMeasuredWidth() / 2, topLeftPoint.y + getExplicitOrMeasuredHeight(), ToolTipPos.TOP);
		}
		updateState();
	}

	private function mouseOutHandler(event:MouseEvent):void {
		hovered = false;
		ManualToolTipManager.hide();
		updateState();
	}

	private function toolInfoActiveChanged(event:Event):void {
		updateState();
	}
}
}