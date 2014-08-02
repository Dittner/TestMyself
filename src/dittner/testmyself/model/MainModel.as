package dittner.testmyself.model {
import dittner.testmyself.service.helpers.screenFactory.ScreenId;

import mvcexpress.mvc.Proxy;

public class MainModel extends Proxy {


	//--------------------------------------
	//  selectedScreenId
	//--------------------------------------
	private var _selectedScreenId:uint = ScreenId.ABOUT;
	public function get selectedScreenId():uint {return _selectedScreenId;}
	public function set selectedScreenId(value:uint):void {
		if (_selectedScreenId != value) {
			_selectedScreenId = value;
		}
	}

}
}
