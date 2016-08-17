package de.dittner.testmyself.model {
import air.net.URLMonitor;

import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.LocalStorage;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.utils.SQLUtils;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogCategory;
import de.dittner.testmyself.model.domain.audioComment.AudioComment;
import de.dittner.testmyself.model.domain.language.Language;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;
import de.dittner.testmyself.model.domain.vocabulary.VocabularyID;
import de.dittner.testmyself.ui.common.audio.LoadRemoteMp3Cmd;
import de.dittner.walter.WalterProxy;

import flash.data.SQLResult;
import flash.data.SQLStatement;
import flash.events.Event;
import flash.events.StatusEvent;
import flash.events.TimerEvent;
import flash.net.Responder;
import flash.net.URLRequest;
import flash.utils.Timer;

public class AppModel extends WalterProxy {
	private static const SELECTED_LANG_CHANGED_MSG:String = "SELECTED_LANG_CHANGED_MSG";
	private static const SELECTED_VOCABULARY_CHANGED_MSG:String = "SELECTED_VOCABULARY_CHANGED_MSG";
	private static const LOAD_MP3_WITH_ERROR_MSG:String = "LOAD_MP3_WITH_ERROR_MSG";
	private static const LOAD_MP3_FOR_TITLES_MSG:String = "LOAD_MP3_FOR_TITLES_MSG";
	private static const LOAD_MP3_INTERVAL_IN_SEC:uint = 30;

	public function AppModel() {
		super();
		networkStatusMonitor = new URLMonitor(new URLRequest("https://www.google.com"));
		networkStatusMonitor.pollInterval = 10000;
		networkStatusMonitor.addEventListener(StatusEvent.STATUS, connectionStatusChanged);
		networkStatusMonitor.start();
	}

	private function connectionStatusChanged(event:StatusEvent):void {
		CLog.info(LogCategory.CONNECTION, "Network status: " + event.code);
		setHasNetworkConnection(networkStatusMonitor.available);
	}

	private var networkStatusMonitor:URLMonitor;

	[Inject]
	public var storage:Storage;

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

	private var notesToLoadMp3:Array = [];
	private var failedLoadMp3Urls:Array = [];
	public function init():void {
		vocabularyOfLoadingMp3 = selectedLanguage.vocabularyHash.read(VocabularyID.DE_WORD);
		failedLoadMp3Urls = LocalStorage.read(LOAD_MP3_WITH_ERROR_MSG) || [];
		loadNoteTitlesIDs();
	}

	private function loadNoteTitlesIDs():void {
		if (LocalStorage.has(LOAD_MP3_FOR_TITLES_MSG) && false) {
			notesToLoadMp3 = LocalStorage.read(LOAD_MP3_FOR_TITLES_MSG);
			timer.addEventListener(TimerEvent.TIMER, loadNextMp3);
			timer.start();
		}
		else {
			var sql:String = "SELECT id,title FROM note WHERE isExample = 0 AND vocabularyID = :vocabularyID";
			var statement:SQLStatement = SQLUtils.createSQLStatement(sql, {vocabularyID: vocabularyOfLoadingMp3.id});
			statement.sqlConnection = storage.sqlConnection;
			statement.execute(-1, new Responder(executeComplete));
		}
	}

	private var timer:Timer = new Timer(LOAD_MP3_INTERVAL_IN_SEC * 1000);
	private function executeComplete(result:SQLResult):void {
		notesToLoadMp3 = result.data is Array ? result.data as Array : [];
		storeTitles();
		timer.addEventListener(TimerEvent.TIMER, loadNextMp3);
		timer.start();
	}

	private function storeTitles():void {
		LocalStorage.write(LOAD_MP3_FOR_TITLES_MSG, notesToLoadMp3);
	}

	private function storeFailedUrls():void {
		LocalStorage.write(LOAD_MP3_WITH_ERROR_MSG, failedLoadMp3Urls);
	}

	private var titleOfLoadingMp3:String;
	private var noteIDOfLoadingMp3:int;
	private var vocabularyOfLoadingMp3:Vocabulary;
	private function loadNextMp3(e:TimerEvent = null):void {
		if (notesToLoadMp3.length > 0) {
			var obj:Object = notesToLoadMp3.pop();
			titleOfLoadingMp3 = obj.title;
			noteIDOfLoadingMp3 = obj.id;
			var cmd:LoadRemoteMp3Cmd = new LoadRemoteMp3Cmd(titleOfLoadingMp3);
			cmd.addCompleteCallback(mp3Loaded);
			cmd.execute();
		}
		else {
			timer.stop();
			trace();
		}
	}

	private function mp3Loaded(op:IAsyncOperation):void {
		if (op.isSuccess) {
			CLog.info(LogCategory.LOAD, "Mp3 successfully loaded for " + titleOfLoadingMp3 + ", total: " + notesToLoadMp3.length);
			if (op.result is AudioComment)
				storage.updateAudioComment(titleOfLoadingMp3, noteIDOfLoadingMp3, op.result, vocabularyOfLoadingMp3);
		}
		else {
			failedLoadMp3Urls.push(titleOfLoadingMp3);
			storeFailedUrls();
		}
		storeTitles();
	}
}
}
