package de.dittner.testmyself.ui.view.settings.components {
import de.dittner.ftpClient.utils.ServerInfo;

import flash.events.Event;
import flash.events.EventDispatcher;

[RemoteClass(alias="de.dittner.testmyself.deutsch.model.settings.SettingsInfo")]
public class SettingsInfo extends EventDispatcher {
	public function SettingsInfo() {
		super();
		backUpServerInfo = new ServerInfo();
		backUpServerInfo.user = "dittner";
		backUpServerInfo.host = "dittner.bget.ru";
		backUpServerInfo.remoteDirPath = "dittner.bget.ru/public_html/testmyself";
	}

	//--------------------------------------
	//  maxAudioRecordDurationInMin
	//--------------------------------------
	private var _maxAudioRecordDurationInMin:Number = 30;
	[Bindable("maxAudioRecordDurationInMinChanged")]
	public function get maxAudioRecordDurationInMin():Number {return _maxAudioRecordDurationInMin;}
	public function set maxAudioRecordDurationInMin(value:Number):void {
		if (_maxAudioRecordDurationInMin != value) {
			_maxAudioRecordDurationInMin = value;
			dispatchEvent(new Event("maxAudioRecordDurationInMinChanged"));
		}
	}

	//--------------------------------------
	//  isDayMode
	//--------------------------------------
	private var _isDayMode:Boolean = true;
	[Bindable("isDayModeChanged")]
	public function get isDayMode():Boolean {return _isDayMode;}
	public function set isDayMode(value:Boolean):void {
		if (_isDayMode != value) {
			_isDayMode = value;
			dispatchEvent(new Event("isDayModeChanged"));
		}
	}

	public var backUpServerInfo:ServerInfo;
}
}
