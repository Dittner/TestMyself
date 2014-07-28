package dittner.testmyself.model {
import dittner.testmyself.service.helpers.screenFactory.ScreenInfo;

import mvcexpress.mvc.Proxy;

public class MainModel extends Proxy {

	//--------------------------------------
	//  activeScreenInfo
	//--------------------------------------
	private var _activeScreenInfo:ScreenInfo;
	public function get activeScreenInfo():ScreenInfo {return _activeScreenInfo;}
	public function set activeScreenInfo(value:ScreenInfo):void {
		if (_activeScreenInfo != value) {
			_activeScreenInfo = value;
		}
	}

}
}
