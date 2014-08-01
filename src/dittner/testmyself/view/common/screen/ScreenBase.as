package dittner.testmyself.view.common.screen {
import flash.events.Event;

import spark.components.Group;

public class ScreenBase extends Group {
	public function ScreenBase() {
		super();
	}

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
	//  headerHeight
	//--------------------------------------
	private var _headerHeight:Number = 35;
	[Bindable("headerHeightChanged")]
	public function get headerHeight():Number {return _headerHeight;}
	public function set headerHeight(value:Number):void {
		if (_headerHeight != value) {
			_headerHeight = value;
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
			dispatchEvent(new Event("paddingChanged"));
		}
	}
}
}
