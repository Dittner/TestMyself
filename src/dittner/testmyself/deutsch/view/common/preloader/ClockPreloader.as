package dittner.testmyself.deutsch.view.common.preloader {
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.events.TimerEvent;
import flash.utils.Timer;
import flash.utils.getTimer;

import mx.core.SpriteAsset;
import mx.events.FlexEvent;
import mx.preloaders.IPreloaderDisplay;
import mx.preloaders.Preloader;

public final class ClockPreloader extends SpriteAsset implements IPreloaderDisplay {

	[Embed(source='/swf/clockBusyIndicator.swf')]
	private var ClockClass:Class;

	private static const MINIMUM_DISPLAY_TIME:uint = 3000;

	public function ClockPreloader(color:uint = 0xFFffFF):void {}

	private var clock:MovieClip;
	private var minDisplayTimer:Timer;

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
		clock = new ClockClass;
		clock.visible = false;
		addChild(clock);
	}

	private function updateClockPos():void {
		if (clock && !clock.visible) {
			clock.visible = true;
			clock.x = Math.floor(stage.stageWidth - clock.width >> 1);
			clock.y = Math.floor(stage.stageHeight - clock.height >> 1);
			trace("stageHeight = " + stage.stageHeight);
		}
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
	}

	protected function progressEventHandler(event:ProgressEvent):void {
		setPercent = Math.min(100 * event.bytesLoaded / event.bytesTotal, 100);
		updateClockPos();
	}

	private var _completeLoading:Boolean = false;
	protected function initCompleteEventHandler(event:FlexEvent):void {
		_completeLoading = true;
		minDisplayTimer = new Timer(100, 0);
		minDisplayTimer.addEventListener(TimerEvent.TIMER, timerHandler);
		minDisplayTimer.start();
	}

	private function timerHandler(event:Event):void {
		setPercent = 100;
	}

}
}