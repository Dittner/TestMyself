package dittner.testmyself.service.helpers.screenFactory {
import flash.display.BitmapData;

public class ScreenInfo {
	public function ScreenInfo(id:uint, title:String, description:String, icon:BitmapData) {
		_id = id;
		_title = title;
		_description = description;
		_icon = icon;
	}

	private var _id:uint;
	public function get id():uint {return _id;}

	private var _title:String;
	public function get title():String {return _title;}

	private var _description:String;
	public function get description():String {return _description;}

	private var _icon:BitmapData;
	public function get icon():BitmapData {return _icon;}

}
}
