package de.dittner.testmyself.ui.common.preloader {
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogTag;
import de.dittner.testmyself.model.Device;

import flash.display.DisplayObject;

import spark.core.SpriteVisualElement;

public class AppBg extends SpriteVisualElement {
	public function AppBg(width:Number = 0, height:Number = 0) {
		super();
		_width = width;
		_height = height;
		createBg();
	}

	[Embed(source="/assets/koeln.jpg")]
	private var BgClass:Class;

	private var bg:DisplayObject;
	private var bgOriginWid:Number = 0;
	private var bgOriginHei:Number = 0;

	private var _width:Number = 0;
	override public function get width():Number {return _width;}
	override public function set width(value:Number):void {
		if (_width != value) {
			_width = value;
			redraw();
		}
	}

	private var _height:Number = 0;
	override public function get height():Number {return _height;}
	override public function set height(value:Number):void {
		if (_height != value) {
			_height = value;
			redraw();
		}
	}

	private function createBg():void {
		bg = new BgClass();
		bgOriginWid = bg.width;
		bgOriginHei = bg.height;
		addChild(bg);
		redraw();
	}

	private function redraw():void {
		if (width != 0 && height != 0) {
			var sc:Number = Math.max(width / bgOriginWid, height / bgOriginHei);
			bg.scaleX = bg.scaleY = sc;
			bg.x = width - bgOriginWid * bg.scaleX >> 1;
			bg.y = height - bgOriginHei * bg.scaleY >> 1;
			if(!Device.isDesktop)
				CLog.info(LogTag.UI, "AppBg width/height/scale: " + width + "/" + height + "/" + sc);
		}
	}

}
}
