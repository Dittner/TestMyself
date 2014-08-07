package dittner.testmyself.model.theme {
import dittner.testmyself.model.model_internal;

use namespace model_internal;

public class Theme {
	public function Theme() {}

	//--------------------------------------
	//  id
	//--------------------------------------
	model_internal var _id:int = -1;
	public function get id():int {return _id;}

	//--------------------------------------
	//  name
	//--------------------------------------
	model_internal var nameChanged:Boolean = false;
	model_internal var _name:String = "";
	public function get name():String {return _name;}
	public function set name(value:String):void {
		if (_name != value) {
			nameChanged = true;
			_name = value;
		}
	}

}
}
