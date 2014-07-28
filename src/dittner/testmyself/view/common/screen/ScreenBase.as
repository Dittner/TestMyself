package dittner.testmyself.view.common.screen {
import dittner.testmyself.service.helpers.screenFactory.ScreenInfo;

import flash.events.Event;

import spark.components.SkinnableContainer;

use namespace screen_internal;

public class ScreenBase extends SkinnableContainer {
	public function ScreenBase() {
		super();
		setStyle("skinClass", ScreenBaseSkin);
	}

	//--------------------------------------
	//  info
	//--------------------------------------
	screen_internal var _info:ScreenInfo;
	public function get info():ScreenInfo {return _info;}

	//--------------------------------------
	//  showBackground
	//--------------------------------------
	private var _showBackground:Boolean = true;
	[Bindable("showBackgroundChanged")]
	public function get showBackground():Boolean {return _showBackground;}
	public function set showBackground(value:Boolean):void {
		if (_showBackground != value) {
			_showBackground = value;
			if(skin) skin.invalidateDisplayList();
			dispatchEvent(new Event("showBackgroundChanged"));
		}
	}

	//--------------------------------------
	//  showHeader
	//--------------------------------------
	private var _showHeader:Boolean = true;
	[Bindable("showHeaderChanged")]
	public function get showHeader():Boolean {return _showHeader;}
	public function set showHeader(value:Boolean):void {
		if (_showHeader != value) {
			_showHeader = value;
			if(skin) skin.invalidateDisplayList();
			dispatchEvent(new Event("showHeaderChanged"));
		}
	}
	//--------------------------------------
	//  headerHeight
	//--------------------------------------
	private var _headerHeight:Number = 35;
	[Bindable("headerHeightChanged")]
	public function get headerHeight():Number {return _headerHeight;}
	public function set headerHeight(value:Number):void {
		if (_headerHeight != value) {
			_headerHeight = value;
			if(skin) skin.invalidateDisplayList();
			dispatchEvent(new Event("headerHeightChanged"));
		}
	}

	//--------------------------------------
	//  padding
	//--------------------------------------
	private var _padding:Number = 20;
	[Bindable("paddingChanged")]
	public function get padding():Number {return _padding;}
	public function set padding(value:Number):void {
		if (_padding != value) {
			_padding = value;
			if(skin) skin.invalidateDisplayList();
			dispatchEvent(new Event("paddingChanged"));
		}
	}

}
}
