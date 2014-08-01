package dittner.testmyself.model {
import dittner.testmyself.message.ScreenMsg;
import dittner.testmyself.service.helpers.screenFactory.ScreenInfo;

import mvcexpress.mvc.Proxy;

public class MainModel extends Proxy {

	//--------------------------------------
	//  activeScreenInfo
	//--------------------------------------
	private var _selectedScreenInfo:ScreenInfo;
	public function get selectedScreenInfo():ScreenInfo {return _selectedScreenInfo;}
	public function set selectedScreenInfo(value:ScreenInfo):void {
		if (_selectedScreenInfo != value) {
			_selectedScreenInfo = value;
			sendMessage(ScreenMsg.SCREEN_INFO_SELECTED_NOTIFICATION, value);
		}
	}

}
}
