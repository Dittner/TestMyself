package dittner.testmyself.view.common.preloader {
import dittner.testmyself.view.utils.FontName;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.events.TimerEvent;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.utils.Timer;
import flash.utils.getTimer;

import flashx.textLayout.formats.TextAlign;

import mx.core.SpriteAsset;
import mx.events.FlexEvent;
import mx.preloaders.IPreloaderDisplay;
import mx.preloaders.Preloader;

public final class SimplePreloader extends SpriteAsset implements IPreloaderDisplay {

	private static const TITLE_FORMAT:TextFormat = new TextFormat(FontName.HELVETICA_NEUE_ULTRALIGHT, 40, 0x4e4f61);
	private static const MINIMUM_DISPLAY_TIME:uint = 3000;

	public function SimplePreloader(color:uint = 0xFFffFF):void {
		addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
	}

	private var minDisplayTimer:Timer;
	private var titleTf:TextField;

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

	//--------------------------------------
	//  fullScreenWidth/Height
	//--------------------------------------
	private var fullScreenWidth:Number = 500;
	private var fullScreenHeight:Number = 500;

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	public function initialize():void {
		createChildren();
		visible = true;
	}

	protected function createChildren():void {
		if (!titleTf) {
			titleTf = new TextField();
			titleTf.selectable = false;
			titleTf.multiline = true;
			titleTf.wordWrap = true;
			titleTf.mouseEnabled = false;
			titleTf.mouseWheelEnabled = false;
			TITLE_FORMAT.align = TextAlign.CENTER;
			titleTf.defaultTextFormat = TITLE_FORMAT;
			titleTf.width = 400;
			titleTf.height = 400;
			addChild(titleTf);
			updateTitlePos();
		}
	}

	private function updateTitlePos():void {
		if (titleTf) {
			titleTf.x = (fullScreenWidth - titleTf.textWidth) / 2;
			titleTf.y = (fullScreenHeight - titleTf.textHeight) / 2;
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
			minDisplayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, progressCompleteHandler);
			minDisplayTimer.delay = 1000;
			minDisplayTimer.repeatCount = 1;
			minDisplayTimer.reset();
			minDisplayTimer.start();
		}
		if (res > _lastRes) {
			_lastRes = res;
		}
		updateTitleText();
		updateTitlePos();
	}

	protected function progressCompleteHandler(event:TimerEvent):void {
		dispatchEvent(new Event(Event.COMPLETE));
	}

	private function updateTitleText():void {
		titleTf.text = "Иницализация\n" + Math.floor(_lastRes) + "%";
		titleTf.width = titleTf.textWidth + 10;
		titleTf.height = titleTf.textHeight + 10;
	}

	protected function progressEventHandler(event:ProgressEvent):void {
		setPercent = Math.min(100 * event.bytesLoaded / event.bytesTotal, 100);
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

	private function addedToStageHandler(event:Event):void {
		removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		fullScreenHeight = stage.fullScreenHeight;
		fullScreenWidth = stage.fullScreenWidth;
		updateTitlePos();
	}

}
}