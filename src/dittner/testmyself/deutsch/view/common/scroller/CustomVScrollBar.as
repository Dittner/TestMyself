package dittner.testmyself.deutsch.view.common.scroller {
import flash.events.Event;
import flash.events.MouseEvent;

import mx.core.mx_internal;

import spark.components.VScrollBar;
import spark.core.IViewport;

use namespace mx_internal;

public class CustomVScrollBar extends VScrollBar {
	override mx_internal function mouseWheelHandler(event:MouseEvent):void {
		const vp:IViewport = viewport;
		if (event.isDefaultPrevented() || !vp || !vp.visible)
			return;

		var delta:Number = event.delta;
		var direction:Number = 0;

		if (delta < 0) direction = 1;
		else if (delta == 0) direction = 0;
		else direction = -1;

		vp.verticalScrollPosition += direction * vp.height * SPEED_COEFFICIENT;

		event.preventDefault();
	}

	private static const SPEED_COEFFICIENT:Number = 0.05;
	override protected function setValue(newValue:Number):void {
		if (!incrementButton || !decrementButton) {
			super.setValue(newValue);
			return;
		}

		if (newValue == maximum)incrementButton.enabled = false;
		else if (incrementButton.enabled == false) incrementButton.enabled = true;

		if (newValue == minimum) decrementButton.enabled = false;
		else if (decrementButton.enabled == false) decrementButton.enabled = true;
		super.setValue(newValue);
	}

	override public function changeValueByStep(increase:Boolean = true):void {
		var prevValue:Number = this.value;
		if (stepSize == 0) return;

		var newValue:Number = (increase) ? value + SPEED_COEFFICIENT * stepSize : value - SPEED_COEFFICIENT * stepSize;
		setValue(newValue);
		if (value != prevValue) dispatchEvent(new Event(Event.CHANGE));
	}

	private var _inLayoutWhenInactive:Boolean = true;
	public function set inLayoutWhenInactive(value:Boolean):void {
		_inLayoutWhenInactive = value;
	}
	override protected function getCurrentSkinState():String {
		if (!_inLayoutWhenInactive) {
			if (maximum <= minimum) {
				includeInLayout = false;
				visible = false;
			}
			else {
				includeInLayout = true;
				visible = true;
			}
		}
		return super.getCurrentSkinState();
	}

}
}