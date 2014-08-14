package dittner.testmyself.view.common.screen {
import dittner.testmyself.view.common.utils.AppSizes;

import flash.events.Event;

import spark.components.Group;

public class ScreenBase extends Group {
	public function ScreenBase() {
		super();
	}
	public const HEADER_HEI:int = AppSizes.SCREEN_HEADER_HEIGHT;
	public const FOOTER_HEI:int = 50;

	//--------------------------------------
	//  title
	//--------------------------------------
	private var _title:String;
	[Bindable("titleChanged")]
	public function get title():String {return _title;}
	public function set title(value:String):void {
		if (_title != value) {
			_title = value;
			dispatchEvent(new Event("titleChanged"));
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
			dispatchEvent(new Event("paddingChanged"));
		}
	}
}
}
