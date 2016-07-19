package de.dittner.testmyself.ui.common.view {
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogCategory;

import flash.display.Graphics;
import flash.utils.getTimer;

import mx.events.FlexEvent;

public class SmartView extends ViewBase {
	public function SmartView() {
		super();
		setStyle("backgroundAlpha", 0);
		addEventListener(FlexEvent.PREINITIALIZE, preinitializeHandler);
		addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Variables
	//
	//----------------------------------------------------------------------------------------------

	public var bgColor:uint = 0xffFFff;
	public var bgColorEnabled:Boolean = true;

	protected var activationTriggered:Boolean = false;
	protected var preinitTime:int;

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------
	//--------------------------------------
	//  abstract
	//--------------------------------------
	protected function preinit():void {
		//abstract
	}

	override protected function activate():void {
		triggerActivation();
	}

	protected function preinitializeHandler(event:FlexEvent):void {
		preinitTime = getTimer();
		preinit();
	}

	protected function creationCompleteHandler(event:FlexEvent):void {
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
		CLog.info(LogCategory.UI, "View: " + msg);
	}

	override protected function updateDisplayList(w:Number, h:Number):void {
		super.updateDisplayList(w, h);
		var g:Graphics = graphics;
		g.clear();
		if (bgColorEnabled) {
			g.beginFill(bgColor);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}
	}
}
}
