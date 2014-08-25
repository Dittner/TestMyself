package dittner.testmyself.view.common.tooltip {
import dittner.testmyself.TestMyselfApp;
import dittner.testmyself.model.settings.SettingsModel;

import flash.events.TimerEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.Timer;

import mvcexpress.mvc.Proxy;

import mx.core.IUIComponent;
import mx.core.IVisualElement;

public class CustomToolTipManager extends Proxy {
	public static var instance:CustomToolTipManager;
	public static var toolTip:IToolTip;

	private static var shown:Boolean = false;
	private static var pendingTimer:Timer;
	private static const ZERO_POINT:Point = new Point();

	[Inject]
	public var settings:SettingsModel;

	override protected function onRegister():void {
		instance = this;
		toolTip = new CustomToolTip();
	}

	public function show(text:String, host:IUIComponent):void {
		if (toolTip && settings.info.showTooltip) {

			var topLeftPoint:Point = host.localToGlobal(ZERO_POINT);
			var globalBounds:Rectangle = new Rectangle(topLeftPoint.x, topLeftPoint.y, host.getExplicitOrMeasuredWidth(), host.getExplicitOrMeasuredHeight());

			if (!pendingTimer) {
				pendingTimer = new Timer(1500, 1);
				pendingTimer.addEventListener(TimerEvent.TIMER_COMPLETE, pendingTimeFinished);
			}

			fillData(text, globalBounds);

			if (!shown) {
				pendingTimer.reset();
				pendingTimer.start();
			}
		}
	}

	private function pendingTimeFinished(event:TimerEvent):void {
		if (!shown) {
			shown = true;
			TestMyselfApp.root.addElement(toolTip as IVisualElement);
		}
	}

	private function fillData(text:String, globalBounds:Rectangle):void {
		toolTip.text = text;
		toolTip.orient(globalBounds);
	}

	public function hide():void {
		if (pendingTimer) pendingTimer.stop();
		if (shown) {
			shown = false;
			TestMyselfApp.root.removeElement(toolTip as IVisualElement);
		}
	}
}
}
