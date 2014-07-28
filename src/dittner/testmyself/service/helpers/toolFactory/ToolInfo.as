package dittner.testmyself.service.helpers.toolFactory {
import dittner.testmyself.view.core.screen_internal;

import flash.display.BitmapData;
import flash.events.Event;
import flash.events.EventDispatcher;

use namespace screen_internal;

public class ToolInfo extends EventDispatcher {
	public static const ACTIVE_CHANGED_EVENT:String = "activeChanged";

	public function ToolInfo(id:uint, description:String, icon:BitmapData) {
		_id = id;
		_description = description;
		_icon = icon;
	}

	private var _id:uint;
	public function get id():uint {return _id;}

	private var _description:String;
	public function get description():String {return _description;}

	private var _icon:BitmapData;
	public function get icon():BitmapData {return _icon;}

	//--------------------------------------
	//  active
	//--------------------------------------
	private var _active:Boolean = false;
	[Bindable("activeChanged")]
	public function get active():Boolean {return _active;}
	public function set active(value:Boolean):void {
		if (_active != value) {
			_active = value;
			dispatchEvent(new Event("activeChanged"));
		}
	}
}
}