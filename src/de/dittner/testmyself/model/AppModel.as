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
import de.dittner.testmyself.model.domain.tag.Tag;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;
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
	//  lang
	//--------------------------------------
	private var _lang:Language;
	public function get lang():Language {return _lang;}

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

			if (CONFIG::LANGUAGE == "DE") {
				_lang = new DeLang(storage);
				initDeLang(_lang);
			}
			else {
				_lang = new EnLang(storage);
				initEnLang(_lang);
			}

			initOp = new AsyncOperation();
		}
		return initOp;
	}

	private function initDeLang(lang:Language):void {
		var op:IAsyncOperation = lang.init();
		op.addCompleteCallback(function (op:IAsyncOperation):void {
			var deWordVoc:Vocabulary = lang.vocabularyHash.read(VocabularyID.DE_WORD);
			if (deWordVoc.tagColl.length == 0) {
				var tag:Tag = deWordVoc.createTag();
				tag.name = "Favorites";
				tag.store();
			}
			loadAppHash();
		});
	}

	private function initEnLang(lang:Language):void {
		var op:IAsyncOperation = lang.init();
		op.addCompleteCallback(function (op:IAsyncOperation):void {
			var enWordVoc:Vocabulary = lang.vocabularyHash.read(VocabularyID.EN_WORD);
			var tag:Tag;

			if (enWordVoc.tagColl.length == 0) {
				tag = enWordVoc.createTag();
				tag.name = "Favorites";
				tag.store();

				tag = enWordVoc.createTag();
				tag.name = "A1: Beginner level";
				tag.store();

				tag = enWordVoc.createTag();
				tag.name = "A2: Elementary level";
				tag.store();

				tag = enWordVoc.createTag();
				tag.name = "B1: Intermediate level";
				tag.store();

				tag = enWordVoc.createTag();
				tag.name = "B2: Upper-Intermediate level";
				tag.store();

				tag = enWordVoc.createTag();
				tag.name = "C1: Advanced level";
				tag.store();

				tag = enWordVoc.createTag();
				tag.name = "C2: Proficiency level";
				tag.store();
			}

			var enVerbVoc:Vocabulary = lang.vocabularyHash.read(VocabularyID.EN_VERB);
			if (enVerbVoc.tagColl.length == 0) {
				tag = enVerbVoc.createTag();
				tag.name = "A1: Beginner level";
				tag.store();

				tag = enVerbVoc.createTag();
				tag.name = "A2: Elementary level";
				tag.store();

				tag = enVerbVoc.createTag();
				tag.name = "B1: Intermediate level";
				tag.store();

				tag = enVerbVoc.createTag();
				tag.name = "B2: Upper-Intermediate level";
				tag.store();

				tag = enVerbVoc.createTag();
				tag.name = "C1: Advanced level";
				tag.store();

				tag = enVerbVoc.createTag();
				tag.name = "C2: Proficiency level";
				tag.store();
			}
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
		if (initOp) initOp.dispatchSuccess();
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Pages
	//
	//----------------------------------------------------------------------------------------------

	public function clearPages():void {
		if (_testPage) _testPage.countAllNotes = true;
		if (_wordPage) _wordPage.countAllNotes = true;
		if (_verbPage) _verbPage.countAllNotes = true;
		if (_lessonPage) _lessonPage.countAllNotes = true;
		if (_searchPage) _searchPage.countAllNotes = true;
	}

	private var _testPage:TestPage;
	public function getTestPage():TestPage {
		if (!_testPage) _testPage = new TestPage();
		return _testPage;
	}

	private var _wordPage:NotePage;
	public function getWordPage():NotePage {
		if (lang.id == LanguageID.DE) {
			if (!_wordPage) _wordPage = new NotePage();
			_wordPage.vocabulary = lang.vocabularyHash.read(VocabularyID.DE_WORD);
			return _wordPage;
		}
		else if (lang.id == LanguageID.EN) {
			if (!_wordPage) _wordPage = new NotePage();
			_wordPage.vocabulary = lang.vocabularyHash.read(VocabularyID.EN_WORD);
			return _wordPage;
		}
		return null;
	}

	private var _verbPage:NotePage;
	public function getVerbPage():NotePage {
		if (lang.id == LanguageID.DE) {
			if (!_verbPage) _verbPage = new NotePage();
			_verbPage.vocabulary = lang.vocabularyHash.read(VocabularyID.DE_VERB);
			return _verbPage;
		}
		else if (lang.id == LanguageID.EN) {
			if (!_verbPage) _verbPage = new NotePage();
			_verbPage.vocabulary = lang.vocabularyHash.read(VocabularyID.EN_VERB);
			return _verbPage;
		}
		return null;
	}

	private var _lessonPage:NotePage;
	public function getLessonPage():NotePage {
		if (lang.id == LanguageID.DE) {
			if (!_lessonPage) _lessonPage = new NotePage();
			_lessonPage.vocabulary = lang.vocabularyHash.read(VocabularyID.DE_LESSON);
			return _lessonPage;
		}
		else if (lang.id == LanguageID.EN) {
			if (!_lessonPage) _lessonPage = new NotePage();
			_lessonPage.vocabulary = lang.vocabularyHash.read(VocabularyID.EN_LESSON);
			return _lessonPage;
		}
		return null;
	}

	private var _searchPage:SearchPage;
	public function getSearchPage():SearchPage {
		if (lang.id == LanguageID.DE) {
			if (!_searchPage) _searchPage = new SearchPage();
			_searchPage.lang = lang;
			return _searchPage;
		}
		else if (lang.id == LanguageID.EN) {
			if (!_searchPage) _searchPage = new SearchPage();
			_searchPage.lang = lang;
			return _searchPage;
		}
		return null;
	}

}
}