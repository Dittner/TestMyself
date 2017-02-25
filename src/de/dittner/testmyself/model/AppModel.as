package de.dittner.testmyself.model {
import air.net.URLMonitor;

import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogTag;
import de.dittner.testmyself.model.domain.language.DeLang;
import de.dittner.testmyself.model.domain.language.EnLang;
import de.dittner.testmyself.model.domain.language.Language;
import de.dittner.walter.WalterProxy;

import flash.events.Event;
import flash.events.StatusEvent;
import flash.net.URLRequest;

public class AppModel extends WalterProxy {
	private static const SELECTED_LANG_CHANGED_MSG:String = "SELECTED_LANG_CHANGED_MSG";
	private static const SELECTED_VOCABULARY_CHANGED_MSG:String = "SELECTED_VOCABULARY_CHANGED_MSG";

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

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	public function init():IAsyncOperation {
		CLog.info(LogTag.SYSTEM, "AppModel initialization is started");

		_deLang = new DeLang(storage);
		_enLang = new EnLang(storage);

		deLang.init();
		var op:IAsyncOperation = enLang.init();
		return op;
	}

	private var networkStatusMonitor:URLMonitor;
	private function connectionStatusChanged(event:StatusEvent):void {
		CLog.info(LogTag.CONNECTION, "Network status: " + event.code);
		setHasNetworkConnection(networkStatusMonitor.available);
	}

}
}
