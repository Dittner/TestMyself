package dittner.testmyself.view.common.renderer {
import dittner.testmyself.service.helpers.toolFactory.Tool;
import dittner.testmyself.view.common.tooltip.CustomToolTipManager;

import flash.display.Bitmap;
import flash.events.Event;
import flash.events.MouseEvent;

public class ToolItemRenderer extends ItemRendererBase {
	private static const ICON_ALPHA_OUT:Number = 0.75;
	private static const ICON_ALPHA_HOVER:Number = 1;
	private static const ICON_ALPHA_SELECTED:Number = 1;
	private static const ICON_ALPHA_INACTIVE:Number = 0.25;

	public function ToolItemRenderer() {
		super();
	}

	private var icon:Bitmap;

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	private function get tool():Tool {
		return data as Tool;
	}

	override public function set data(value:Object):void {
		if (data != value) {
			if (tool) tool.removeEventListener(Tool.ACTIVE_CHANGED_EVENT, toolActiveChanged);
			super.data = value;
			if (tool) tool.addEventListener(Tool.ACTIVE_CHANGED_EVENT, toolActiveChanged);
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
		if (tool) icon.bitmapData = tool.icon;
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
		if (tool.active) {
			if (selected) {
				icon.alpha = ICON_ALPHA_SELECTED;
			}
			else if (hovered) {
				icon.alpha = ICON_ALPHA_HOVER;
			}
			else {
				icon.alpha = ICON_ALPHA_OUT;
			}
			mouseEnabled = mouseChildren = true;
		}
		else {
			icon.alpha = ICON_ALPHA_INACTIVE;
			mouseEnabled = mouseChildren = false;
		}
	}

	override protected function overHandler(event:MouseEvent):void {
		if (!selected) CustomToolTipManager.show(tool.description, this);
		super.overHandler(event);
	}

	override protected function outHandler(event:MouseEvent):void {
		CustomToolTipManager.hide();
		updateState();
		super.outHandler(event);
	}

	private function toolActiveChanged(event:Event):void {
		updateState();
	}
}
}