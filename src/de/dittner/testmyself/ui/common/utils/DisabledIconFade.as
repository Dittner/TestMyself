package de.dittner.testmyself.ui.common.utils {
import com.greensock.TweenLite;

import flash.events.Event;

import mx.core.UIComponent;

import spark.primitives.BitmapImage;

public class DisabledIconFade {
	private static const DISABLED_ICON_ALPHA:Number = 0.5;

	public function DisabledIconFade() {}

	private var disabledIcon:BitmapImage;
	private var parent:UIComponent;

	public function activate(parent:UIComponent, disabledIcon:BitmapImage):void {
		dispose();
		this.parent = parent;
		this.disabledIcon = disabledIcon;
		if (parent) {
			disabledIcon.alpha = (parent as UIComponent).enabled ? 0 : 0.5;
			parent.addEventListener("enabledChanged", enabledChanged);
		}
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
		var alphaTo:Number = parent is UIComponent && (parent as UIComponent).enabled ? 0 : DISABLED_ICON_ALPHA;
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

	public function dispose():void {
		if (parent) parent.removeEventListener("enabledChanged", enabledChanged);
	}

}
}
