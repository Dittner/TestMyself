package dittner.testmyself.view.common.screen {
import dittner.testmyself.view.common.utils.AppSizes;

import flash.events.Event;

import spark.components.Group;

public class ScreenBase extends Group {
	public function ScreenBase() {
		super();
		maxWidth = AppSizes.SCREEN_MAX_WIDTH;
	}
	public const HEADER_HEI:int = AppSizes.SCREEN_HEADER_HEIGHT;
	public const FOOTER_HEI:int = 50;
	public const PADDING:uint = 20;

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

}
}
