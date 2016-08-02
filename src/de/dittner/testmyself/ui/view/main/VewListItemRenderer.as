package de.dittner.testmyself.ui.view.main {
import com.greensock.TweenLite;

import de.dittner.testmyself.ui.common.renderer.ItemRendererBase;
import de.dittner.testmyself.ui.common.view.ViewInfo;

import flash.display.Bitmap;
import flash.display.Graphics;
import flash.events.Event;
import flash.events.MouseEvent;

import spark.components.DataGroup;

public class VewListItemRenderer extends ItemRendererBase {
	private static const ICON_ALPHA_OUT:Number = 0.5;
	private static const ICON_ALPHA_SELECTED:Number = 1;

	private static const DISABLED_ICON_ALPHA:Number = 0.65;

	private static const VGAP:Number = 20;

	public function VewListItemRenderer() {
		super();
		addEventListener(Event.ADDED_TO_STAGE, addedToStage);
	}

	private var icon:Bitmap;
	private var disabledIcon:Bitmap;

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	private function get parentGroup():DataGroup {
		return parent as DataGroup;
	}

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

		disabledIcon = new Bitmap();
		disabledIcon.alpha = 0;
		addChild(disabledIcon);
	}

	override protected function commitProperties():void {
		super.commitProperties();
		if (viewInfo) {
			icon.bitmapData = viewInfo.icon;
			disabledIcon.bitmapData = viewInfo.disabledIcon;
		}
	}

	override protected function measure():void {
		measuredMinWidth = measuredWidth = icon ? icon.width : 0;
		measuredHeight = measuredMinHeight = icon ? icon.height + VGAP : 50 + VGAP;
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.clear();
		g.beginFill(0.0001);
		g.drawRect(0, 0, w, h);
		g.endFill();

		icon.alpha = selected ? ICON_ALPHA_SELECTED : ICON_ALPHA_OUT;

		disabledIcon.x = icon.x = (w - icon.width) / 2;
		disabledIcon.y = icon.y = (h - icon.height) / 2;
	}

	override protected function overHandler(event:MouseEvent):void {
		if (!selected) {
			icon.alpha = 1;
		}
	}

	override protected function outHandler(event:MouseEvent):void {
		if (!selected) {
			icon.alpha = ICON_ALPHA_OUT;
		}
	}

	private function addedToStage(event:Event):void {
		removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
		addEventListener(Event.REMOVED_FROM_STAGE, removeFromStage);
		if (parent) parent.addEventListener("enabledChanged", enabledChanged);
	}

	private function enabledChanged(e:Event):void {
		if (disabledIcon) {
			if (isAnimating) isParentEnabledStateChanged = true;
			else startAlphaAnimation();
		}
	}

	private var isParentEnabledStateChanged:Boolean = false;
	private var isAnimating:Boolean = false;
	private function startAlphaAnimation():void {
		var alphaTo:Number = parentGroup.enabled ? 0 : DISABLED_ICON_ALPHA;
		if (disabledIcon.alpha != alphaTo) {
			isAnimating = true;
			TweenLite.to(disabledIcon, 1, {alpha: alphaTo, onComplete: animationComplete});
		}
	}

	private function animationComplete():void {
		isAnimating = false;
		if (isParentEnabledStateChanged) {
			isParentEnabledStateChanged = false;
			startAlphaAnimation();
		}
	}

	private function removeFromStage(event:Event):void {
		removeEventListener(Event.REMOVED_FROM_STAGE, removeFromStage);
		if (parent) parent.removeEventListener("enabledChanged", enabledChanged);
		addEventListener(Event.ADDED_TO_STAGE, addedToStage);
	}
}
}
