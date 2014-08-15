package dittner.testmyself.model.common {
import flash.net.SharedObject;

import mvcexpress.mvc.Proxy;

public class SettingsModel extends Proxy {

	private var _info:SettingsInfo;
	public function get info():SettingsInfo {return _info;}

	private var so:SharedObject;
	override protected function onRegister():void {
		so = SharedObject.getLocal("settings");
		restore()
	}

	private function restore():void {
		if (so && so.data["info"]) {
			_info = so.data.info;
		}
		else _info = new SettingsInfo();
	}

	public function store(info:SettingsInfo):void {
		_info = info;
		so.data.info = info;
		so.flush();
	}

	override protected function onRemove():void {
		so.close();
	}

}
}