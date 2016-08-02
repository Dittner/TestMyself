package de.dittner.testmyself.ui.common.view {
import flash.display.BitmapData;

public class ViewInfo {
	public function ViewInfo(id:String, title:String, description:String, icon:BitmapData, disabledIcon:BitmapData) {
		_id = id;
		_title = title;
		_description = description;
		_icon = icon;
		_disabledIcon = disabledIcon;
	}

	private var _id:String;
	public function get id():String {return _id;}

	private var _title:String;
	public function get title():String {return _title;}

	private var _description:String;
	public function get description():String {return _description;}

	private var _icon:BitmapData;
	public function get icon():BitmapData {return _icon;}

	private var _disabledIcon:BitmapData;
	public function get disabledIcon():BitmapData {return _disabledIcon;}

}
}
