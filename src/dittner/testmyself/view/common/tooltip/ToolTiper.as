package dittner.testmyself.view.common.tooltip {
import dittner.testmyself.TestMyselfApp;

import flash.display.Stage;

import flash.events.TimerEvent;
import flash.utils.Timer;

import mx.core.FlexGlobals;

import mx.core.IToolTip;
import mx.core.IVisualElement;

public class ToolTiper {
	public static var toolTip:IToolTip;

	private static var shown:Boolean = false;
	private static var pendingTimer:Timer;

	public static function show(text:String, stageX:Number, stageY:Number):void {
		if (toolTip) {
			if (!pendingTimer) {
				pendingTimer = new Timer(2000, 1);
				pendingTimer.addEventListener(TimerEvent.TIMER_COMPLETE, pendingTimeFinished);
			}

			fillData(text, stageX, stageY);

			if (!shown) {
				pendingTimer.reset();
				pendingTimer.start();
			}
		}
	}

	private static function pendingTimeFinished(event:TimerEvent):void {
		if (!shown) {
			shown = true;
			TestMyselfApp.root.addElement(toolTip as IVisualElement);
		}
	}

	private static function fillData(text:String, stageX:Number, stageY:Number):void {
		var arrowYOffset:int = 34;
		toolTip.text = text;
		toolTip.x = stageX;
		if (stageY - arrowYOffset < 0) {
			toolTip.y = 0;
		}
		else if (stageY + toolTip.height > TestMyselfApp.root.height) {
			toolTip.y = TestMyselfApp.root.height - toolTip.height;
		}
		else {
			toolTip.y = stageY - arrowYOffset;
		}
	}

	public static function hide():void {
		pendingTimer.stop();
		if (shown) {
			shown = false;
			TestMyselfApp.root.removeElement(toolTip as IVisualElement);
		}
	}
}
}
