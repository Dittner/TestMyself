package de.dittner.testmyself.ui.view.settings.components {
import de.dittner.ftpClient.utils.IServerInfo;
import de.dittner.testmyself.backend.LocalStorageKey;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogTag;
import de.dittner.testmyself.model.AppModel;
import de.dittner.testmyself.model.Device;
import de.dittner.testmyself.ui.common.utils.AppColors;
import de.dittner.walter.Walter;

import flash.events.Event;
import flash.events.EventDispatcher;

[RemoteClass(alias="de.dittner.testmyself.deutsch.model.settings.SettingsInfo")]
public class SettingsInfo extends EventDispatcher implements IServerInfo {
	public function SettingsInfo() {
		super();
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
			store();
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
			store();
			dispatchEvent(new Event("appBgColorChanged"));
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  ServerInfo
	//
	//----------------------------------------------------------------------------------------------

	//--------------------------------------
	//  host
	//--------------------------------------
	private var _host:String = "dittner.bget.ru";
	[Bindable("hostChanged")]
	public function get host():String {return _host;}
	public function set host(value:String):void {
		if (_host != value) {
			_host = value;
			store();
			dispatchEvent(new Event("hostChanged"));
		}
	}

	//--------------------------------------
	//  port
	//--------------------------------------
	private var _port:String = "21";
	[Bindable("portChanged")]
	public function get port():String {return _port;}
	public function set port(value:String):void {
		if (_port != value) {
			_port = value;
			store();
			dispatchEvent(new Event("portChanged"));
		}
	}

	//--------------------------------------
	//  user
	//--------------------------------------
	private var _user:String = "dittner";
	[Bindable("userChanged")]
	public function get user():String {return _user;}
	public function set user(value:String):void {
		if (_user != value) {
			_user = value;
			store();
			dispatchEvent(new Event("userChanged"));
		}
	}

	//--------------------------------------
	//  password
	//--------------------------------------
	private var _password:String = "";
	[Bindable("passwordChanged")]
	public function get password():String {return _password;}
	public function set password(value:String):void {
		if (_password != value) {
			_password = value;
			store();
			dispatchEvent(new Event("passwordChanged"));
		}
	}

	//--------------------------------------
	//  remoteDirPath
	//--------------------------------------
	private var _remoteDirPath:String = "dittner.bget.ru/public_html/" + Device.appName;
	[Bindable("remoteDirPathChanged")]
	public function get remoteDirPath():String {return _remoteDirPath;}
	public function set remoteDirPath(value:String):void {
		if (_remoteDirPath != value) {
			_remoteDirPath = value;
			store();
			dispatchEvent(new Event("remoteDirPathChanged"));
		}
	}

	private function store():void {
		var appModel:AppModel = Walter.instance.getProxy("appModel") as AppModel;
		if (appModel) {
			appModel.hash.write(LocalStorageKey.SETTINGS_KEY, this);
		}
		else {
			CLog.err(LogTag.STORAGE, "No appModel is found!");
		}
	}
}
}
