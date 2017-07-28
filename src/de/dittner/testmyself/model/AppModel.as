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
import de.dittner.testmyself.model.domain.language.LanguageID;
import de.dittner.testmyself.model.domain.vocabulary.VocabularyID;
import de.dittner.testmyself.ui.common.page.NotePage;
import de.dittner.testmyself.ui.common.page.SearchPage;
import de.dittner.testmyself.ui.common.page.TestPage;
import de.dittner.testmyself.ui.view.settings.components.SettingsInfo;
import de.dittner.walter.WalterProxy;

import flash.events.Event;
import flash.events.StatusEvent;
import flash.net.URLRequest;

public class AppModel extends WalterProxy {
	public static const HASH_CHANGED_MSG:String = "HASH_CHANGED_MSG";
	public static const SELECTED_LANG_CHANGED_MSG:String = "SELECTED_LANG_CHANGED_MSG";
	public static const SELECTED_VOCABULARY_CHANGED_MSG:String = "SELECTED_VOCABULARY_CHANGED_MSG";
	public static const NETWORK_CONNECTION_CHANGED_MSG:String = "NETWORK_CONNECTION_CHANGED_MSG";
	public static const SETTINGS_CHANGED_MSG:String = "SETTINGS_CHANGED_MSG";

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
			sendMessage(HASH_CHANGED_MSG, hash);
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
			sendMessage(SETTINGS_CHANGED_MSG, settings);
		}
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
		sendMessage(NETWORK_CONNECTION_CHANGED_MSG, networkStatusMonitor.available);
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

	public function loadAppHash():IAsyncOperation {
		var op:IAsyncOperation = storage.load("appHash");
		op.addCompleteCallback(appHashLoaded);
		return op;
	}

	private function appHashLoaded(op:IAsyncOperation):void {
		if (op.result is HashData) {
			hash = op.result;
		}
		else {
			hash = new HashData();
			hash.key = "appHash";
		}

		setSettings(hash.read(LocalStorageKey.SETTINGS_KEY) || new SettingsInfo());
		if(initOp) initOp.dispatchSuccess();
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Pages
	//
	//----------------------------------------------------------------------------------------------

	public function clearPages():void {
		if(_testPage) _testPage.countAllNotes = true;

		if(_deWordPage) _deWordPage.countAllNotes = true;
		if(_enWordPage) _enWordPage.countAllNotes = true;

		if(_deVerbPage) _deVerbPage.countAllNotes = true;
		if(_enVerbPage) _enVerbPage.countAllNotes = true;

		if(_deLessonPage) _deLessonPage.countAllNotes = true;
		if(_enLessonPage) _enLessonPage.countAllNotes = true;

		if(_deSearchPage) _deSearchPage.countAllNotes = true;
		if(_enSearchPage) _enSearchPage.countAllNotes = true;
	}

	private var _testPage:TestPage;
	public function getTestPage():TestPage {
		if(!_testPage) _testPage = new TestPage();
		return _testPage;
	}

	private var _deWordPage:NotePage;
	private var _enWordPage:NotePage;
	public function getWordPage():NotePage {
		if(selectedLanguage.id == LanguageID.DE) {
			if(!_deWordPage) _deWordPage = new NotePage();
			_deWordPage.vocabulary = deLang.vocabularyHash.read(VocabularyID.DE_WORD);
			return _deWordPage;
		}
		else if(selectedLanguage.id == LanguageID.EN) {
			if(!_enWordPage) _enWordPage = new NotePage();
			_enWordPage.vocabulary = enLang.vocabularyHash.read(VocabularyID.EN_WORD);
			return _enWordPage;
		}
		return null;
	}

	private var _deVerbPage:NotePage;
	private var _enVerbPage:NotePage;
	public function getVerbPage():NotePage {
		if(selectedLanguage.id == LanguageID.DE) {
			if(!_deVerbPage) _deVerbPage = new NotePage();
			_deVerbPage.vocabulary = deLang.vocabularyHash.read(VocabularyID.DE_VERB);
			return _deVerbPage;
		}
		else if(selectedLanguage.id == LanguageID.EN) {
			if(!_enVerbPage) _enVerbPage = new NotePage();
			_enVerbPage.vocabulary = enLang.vocabularyHash.read(VocabularyID.EN_VERB);
			return _enVerbPage;
		}
		return null;
	}

	private var _deLessonPage:NotePage;
	private var _enLessonPage:NotePage;
	public function getLessonPage():NotePage {
		if(selectedLanguage.id == LanguageID.DE) {
			if(!_deLessonPage) _deLessonPage = new NotePage();
			_deLessonPage.vocabulary = deLang.vocabularyHash.read(VocabularyID.DE_LESSON);
			return _deLessonPage;
		}
		else if(selectedLanguage.id == LanguageID.EN) {
			if(!_enLessonPage) _enLessonPage = new NotePage();
			_enLessonPage.vocabulary = enLang.vocabularyHash.read(VocabularyID.EN_LESSON);
			return _enLessonPage;
		}
		return null;
	}

	private var _deSearchPage:SearchPage;
	private var _enSearchPage:SearchPage;
	public function getSearchPage():SearchPage {
		if(selectedLanguage.id == LanguageID.DE) {
			if(!_deSearchPage) _deSearchPage = new SearchPage();
			_deSearchPage.lang = deLang;
			return _deSearchPage;
		}
		else if(selectedLanguage.id == LanguageID.EN) {
			if(!_enSearchPage) _enSearchPage = new SearchPage();
			_enSearchPage.lang = enLang;
			return _enSearchPage;
		}
		return null;
	}


}
}