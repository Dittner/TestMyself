package de.dittner.testmyself.ui.view.settings.components {
import de.dittner.ftpClient.utils.ServerInfo;
import de.dittner.testmyself.ui.common.utils.AppColors;

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
	//  appBgColor
	//--------------------------------------
	private var _appBgColor:uint = AppColors.APP_BG_WHITE;
	[Bindable("appBgColorChanged")]
	public function get appBgColor():uint {return _appBgColor;}
	public function set appBgColor(value:uint):void {
		if (_appBgColor != value) {
			_appBgColor = value;
			dispatchEvent(new Event("appBgColorChanged"));
		}
	}

	public var backUpServerInfo:ServerInfo;
}
}
