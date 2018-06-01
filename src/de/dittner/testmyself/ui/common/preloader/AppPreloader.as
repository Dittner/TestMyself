package de.dittner.testmyself.ui.common.preloader {
import de.dittner.async.AsyncCallbacksLib;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogTag;
import de.dittner.testmyself.model.Device;
import de.dittner.testmyself.ui.common.utils.AppColors;
import de.dittner.testmyself.utils.Values;

import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.events.TimerEvent;
import flash.utils.Timer;
import flash.utils.getTimer;

import mx.events.FlexEvent;
import mx.preloaders.IPreloaderDisplay;
import mx.preloaders.Preloader;

public final class AppPreloader extends Sprite implements IPreloaderDisplay {

	private static const MINIMUM_DISPLAY_TIME:uint = 1000;

	public function AppPreloader(color:uint = 0xFFffFF):void {
		addEventListener(Event.ADDED_TO_STAGE, addedToStage);
	}

	private var minDisplayTimer:Timer;
	private var bg:AppBg;
	private var progressBar:Shape;

	private function addedToStage(event:Event):void {
		removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
		Device.init(stage);
		if (stage.nativeWindow)
			stage.nativeWindow.x = CONFIG::LANGUAGE == "DE" ? 0 : stage.fullScreenWidth - stage.nativeWindow.width;
		AsyncCallbacksLib.fps = 30;
		AsyncCallbacksLib.stage = stage;
		CLog.run();
		CLog.info(LogTag.SYSTEM, "Device mode: " + (Device.stage.wmodeGPU ? "gpu" : "cpu"));
		CLog.logMemoryAndFPS(true);
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	//--------------------------------------
	//  backgroundAlpha
	//--------------------------------------
	private var _backgroundAlpha:Number = 1;
	public function get backgroundAlpha():Number {return _backgroundAlpha;}
	public function set backgroundAlpha(value:Number):void {
		if (_backgroundAlpha != value) {
			_backgroundAlpha = value;
		}
	}

	//--------------------------------------
	//  _backgroundColor
	//--------------------------------------
	private var _backgroundColor:uint = 0;
	public function get backgroundColor():uint {return _backgroundColor;}
	public function set backgroundColor(value:uint):void {
		if (_backgroundColor != value) {
			_backgroundColor = value;
		}
	}

	//--------------------------------------
	//  backgroundImage
	//--------------------------------------
	private var _backgroundImage:Object;
	public function get backgroundImage():Object {return _backgroundImage;}
	public function set backgroundImage(value:Object):void {
		if (_backgroundImage != value) {
			_backgroundImage = value;
		}
	}

	//--------------------------------------
	//  backgroundSize
	//--------------------------------------
	private var _backgroundSize:String;
	public function get backgroundSize():String {return _backgroundSize;}
	public function set backgroundSize(value:String):void {
		if (_backgroundSize != value) {
			_backgroundSize = value;
		}
	}

	//--------------------------------------
	//  preloader
	//--------------------------------------
	private var _preloader:Sprite;
	public function get preloader():Sprite {return _preloader;}
	public function set preloader(value:Sprite):void {
		_preloader = value as Preloader;
		_preloader.addEventListener(FlexEvent.INIT_COMPLETE, initCompleteEventHandler);
		_preloader.addEventListener(ProgressEvent.PROGRESS, progressEventHandler);

	}

	//--------------------------------------
	//  stageHeight
	//--------------------------------------
	private var _stageHeight:Number = 500;
	public function get stageHeight():Number {return _stageHeight;}
	public function set stageHeight(value:Number):void {
		if (_stageHeight != value) {
			_stageHeight = value;
		}
	}

	//--------------------------------------
	//  stageWidth
	//--------------------------------------
	private var _stageWidth:Number = 500;
	public function get stageWidth():Number {return _stageWidth;}
	public function set stageWidth(value:Number):void {
		if (_stageWidth != value) {
			_stageWidth = value;
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	public function initialize():void {
		start();
	}

	private function start(duration:Number = 50):void {
		createChildren();
		visible = true;
	}

	protected function createChildren():void {
		bg = Device.isDesktop ? new AppBg(Values.PT768, stage.fullScreenHeight) : new AppBg(Values.PT768, stage.stageHeight);
		bg.x = 0;
		bg.y = Device.verticalPadding;
		addChild(bg);

		progressBar = new Shape();
		addChild(progressBar);

		stageWidth = Values.PT768;
		stageHeight = stage.fullScreenHeight;
	}

	private var _lastRes:Number = 0;
	private function set setPercent(val:Number):void {
		var res:uint;
		if ((getTimer() / MINIMUM_DISPLAY_TIME) >= 1)
			res = Math.round(val);
		else res = Math.round(val * getTimer() / MINIMUM_DISPLAY_TIME);
		if ((res >= 100) && _completeLoading) {

			minDisplayTimer.stop();
			minDisplayTimer.removeEventListener(TimerEvent.TIMER, timerHandler);

			dispatchEvent(new Event(Event.COMPLETE));
		}
		if (res > _lastRes) {
			_lastRes = res;
		}

		progressBar.x = stageWidth - Values.PT300 >> 1;
		progressBar.y = stageHeight / 2;
		progressBar.graphics.clear();

		progressBar.graphics.beginFill(AppColors.WHITE);
		progressBar.graphics.drawRect(0, 0, Values.PT300, Values.PT2);
		progressBar.graphics.endFill();

		progressBar.graphics.beginFill(AppColors.PINK);
		progressBar.graphics.drawRect(0, 0, res * Values.PT2, Values.PT2);
		progressBar.graphics.endFill();

		if(stage) {
			bg.x = 0;
			bg.y = Device.verticalPadding;
			bg.width = Device.isDesktop ? Values.PT768 : stage.stageWidth;
			bg.height = stage.fullScreenHeight;
		}
	}

	protected function progressEventHandler(event:ProgressEvent):void {
		setPercent = Math.min(100 * event.bytesLoaded / event.bytesTotal, 100);
	}

	private var _completeLoading:Boolean = false;
	protected function initCompleteEventHandler(event:FlexEvent):void {
		_completeLoading = true;
		minDisplayTimer = new Timer(10, 0);
		minDisplayTimer.addEventListener(TimerEvent.TIMER, timerHandler);
		minDisplayTimer.start();
	}

	private function timerHandler(event:Event):void {
		setPercent = 100;
	}

}
}