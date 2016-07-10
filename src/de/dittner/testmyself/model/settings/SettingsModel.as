package de.dittner.testmyself.model.settings {
import de.dittner.satelliteFlight.proxy.SFProxy;

import flash.net.SharedObject;

public class SettingsModel extends SFProxy {

	private var _info:SettingsInfo;
	public function get info():SettingsInfo {return _info;}

	private var so:SharedObject;

	override protected function activate():void {
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

	override protected function deactivate():void {
		so.close();
	}

}
}