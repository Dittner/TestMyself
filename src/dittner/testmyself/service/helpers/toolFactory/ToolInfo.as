package dittner.testmyself.service.helpers.toolFactory {
import dittner.testmyself.view.*;
import dittner.testmyself.view.core.view_internal;

import flash.display.BitmapData;

use namespace view_internal;

public class ToolInfo {
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
}
}