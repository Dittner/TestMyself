package de.dittner.testmyself.ui.common.view {
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogTag;

import flash.utils.getTimer;

import mx.events.FlexEvent;

public class SmartView extends ViewBase {
	public function SmartView() {
		super();
		percentWidth = 100;
		percentHeight = 100;
		horizontalCenter = 0;
		setStyle("backgroundAlpha", 0);
		addEventListener(FlexEvent.PREINITIALIZE, preinitializeHandler);
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Variables
	//
	//----------------------------------------------------------------------------------------------

	protected var activationTriggered:Boolean = false;
	protected var preinitTime:int;

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	protected function preinit():void {}

	override internal function invalidate(navigationPhase:String):void {
		if (navigationPhase == NavigationPhase.VIEW_ACTIVATE)
			triggerActivation();
		super.invalidate(navigationPhase);
	}

	protected function preinitializeHandler(event:FlexEvent):void {
		preinitTime = getTimer();
		preinit();
	}

	override protected function creationCompleteHandler(event:FlexEvent):void {
		super.creationCompleteHandler(event);
		triggerActivation();
	}

	protected function triggerActivation():void {
		if (activationTriggered) return;

		if (isActive && initialized) {
			activationTriggered = true;
			logCreationTime(getTimer() - preinitTime);
		}
	}

	protected function logCreationTime(time:int):void {
		var msg:String = fullName + " creation time:" + time + "ms";
		CLog.info(LogTag.UI, "View: " + msg);
	}
}
}
