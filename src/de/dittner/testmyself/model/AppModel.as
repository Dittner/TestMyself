package de.dittner.testmyself.model {
import air.net.URLMonitor;

import de.dittner.async.AsyncOperation;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.LocalStorageKey;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.utils.HashData;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogTag;
import de.dittner.testmyself.model.domain.language.DeLang;
import de.dittner.testmyself.model.domain.language.EnLang;
import de.dittner.testmyself.model.domain.language.Language;
import de.dittner.testmyself.ui.view.settings.components.SettingsInfo;
import de.dittner.walter.WalterProxy;

import flash.events.Event;
import flash.events.StatusEvent;
import flash.net.URLRequest;

public class AppModel extends WalterProxy {
	public static const HASH_CHANGED_MSG:String = "HASH_CHANGED_MSG";
	public static const SELECTED_LANG_CHANGED_MSG:String = "SELECTED_LANG_CHANGED_MSG";
	public static const SELECTED_VOCABULARY_CHANGED_MSG:String = "SELECTED_VOCABULARY_CHANGED_MSG";

	public function AppModel() {
		super();
		networkStatusMonitor = new URLMonitor(new URLRequest("https://www.google.com"));
		networkStatusMonitor.pollInterval = 10000;
		networkStatusMonitor.addEventListener(StatusEvent.STATUS, connectionStatusChanged);
		networkStatusMonitor.start();
	}

	[Inject]
	public var storage:Storage;

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	//--------------------------------------
	//  deLang
	//--------------------------------------
	private var _deLang:Language;
	[Bindable("deLangChanged")]
	public function get deLang():Language {return _deLang;}

	//--------------------------------------
	//  enLang
	//--------------------------------------
	private var _enLang:Language;
	[Bindable("enLangChanged")]
	public function get enLang():Language {return _enLang;}

	//--------------------------------------
	//  selectedLanguage
	//--------------------------------------
	private var _selectedLanguage:Language;
	[Bindable("selectedLanguageChanged")]
	public function get selectedLanguage():Language {return _selectedLanguage;}
	public function set selectedLanguage(value:Language):void {
		if (_selectedLanguage != value) {
			_selectedLanguage = value;
			dispatchEvent(new Event("selectedLanguageChanged"));
			sendMessage(SELECTED_LANG_CHANGED_MSG, selectedLanguage);
		}
	}

	//--------------------------------------
	//  hasNetworkConnection
	//--------------------------------------
	private var _hasNetworkConnection:Boolean = false;
	[Bindable("hasNetworkConnectionChanged")]
	public function get hasNetworkConnection():Boolean {return _hasNetworkConnection;}
	private function setHasNetworkConnection(value:Boolean):void {
		if (_hasNetworkConnection != value) {
			_hasNetworkConnection = value;
			dispatchEvent(new Event("hasNetworkConnectionChanged"));
		}
	}

	//--------------------------------------
	//  hash
	//--------------------------------------
	private var _hash:HashData;
	[Bindable("hashChanged")]
	public function get hash():HashData {return _hash;}
	public function set hash(value:HashData):void {
		if (_hash != value) {
			_hash = value;
			dispatchEvent(new Event("hashChanged"));
			sendMessage(HASH_CHANGED_MSG, selectedLanguage);
		}
	}

	//--------------------------------------
	//  settings
	//--------------------------------------
	private var _settings:SettingsInfo;
	[Bindable("settingsChanged")]
	public function get settings():SettingsInfo {return _settings;}
	private function setSettings(value:SettingsInfo):void {
		if (_settings != value) {
			_settings = value;
			dispatchEvent(new Event("settingsChanged"));
		}
	}

	public function storeSettings():void {
		hash.write(LocalStorageKey.SETTINGS_KEY, settings);
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	private var networkStatusMonitor:URLMonitor;
	private function connectionStatusChanged(event:StatusEvent):void {
		CLog.info(LogTag.CONNECTION, "Network status: " + event.code);
		setHasNetworkConnection(networkStatusMonitor.available);
	}

	private var initOp:IAsyncOperation;
	public function init():IAsyncOperation {
		if (!initOp) {
			CLog.info(LogTag.SYSTEM, "AppModel initialization is started");

			_deLang = new DeLang(storage);
			_enLang = new EnLang(storage);

			initOp = new AsyncOperation();
			initDeLang();
		}
		return initOp;
	}

	private function initDeLang():void {
		var op:IAsyncOperation = deLang.init();
		op.addCompleteCallback(function (op:IAsyncOperation):void {
			initEnLang();
		});
	}

	private function initEnLang():void {
		var op:IAsyncOperation = enLang.init();
		op.addCompleteCallback(function (op:IAsyncOperation):void {
			loadAppHash();
		});
	}

	public function loadAppHash():void {
		var op:IAsyncOperation = storage.load("appHash");
		op.addCompleteCallback(function (op:IAsyncOperation):void {
			if (op.result is HashData) {
				hash = op.result;
			}
			else {
				hash = new HashData();
				hash.key = "appHash";
			}

			setSettings(hash.read(LocalStorageKey.SETTINGS_KEY) || new SettingsInfo());
			initOp.dispatchSuccess();
		});
	}

}
}
