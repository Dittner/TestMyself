package dittner.testmyself.view.common.tooltip {
import dittner.testmyself.TestMyselfApp;

import flash.events.TimerEvent;
import flash.utils.Timer;

import mx.core.IVisualElement;

public class ManualToolTipManager {
	public static var toolTip:IManualToolTip;

	private static var shown:Boolean = false;
	private static var pendingTimer:Timer;

	public static function show(text:String, stageX:Number, stageY:Number, arrowDirection:String):void {
		if (toolTip) {
			if (!pendingTimer) {
				pendingTimer = new Timer(1500, 1);
				pendingTimer.addEventListener(TimerEvent.TIMER_COMPLETE, pendingTimeFinished);
			}

			fillData(text, stageX, stageY, arrowDirection);

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

	private static function fillData(text:String, stageX:Number, stageY:Number, arrowDirection:String):void {
		toolTip.text = text;
		toolTip.orient(stageX, stageY, arrowDirection);
	}

	public static function hide():void {
		if(pendingTimer) pendingTimer.stop();
		if (shown) {
			shown = false;
			TestMyselfApp.root.removeElement(toolTip as IVisualElement);
		}
	}
}
}
