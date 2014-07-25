package dittner.testmyself.view.core {
import flash.display.BitmapData;

use namespace view_internal;

public class ViewInfo {
	public function ViewInfo() {}

	//--------------------------------------
	//  id
	//--------------------------------------
	view_internal var _id:uint;
	public function get id():uint {return _id;}

	//--------------------------------------
	//  title
	//--------------------------------------
	view_internal var _title:String;
	public function get title():String {return _title;}

	//--------------------------------------
	//  description
	//--------------------------------------
	view_internal var _description:String;
	public function get description():String {return _description;}

	//--------------------------------------
	//  icon
	//--------------------------------------
	view_internal var _icon:BitmapData;
	public function get icon():BitmapData {return _icon;}

}
}
