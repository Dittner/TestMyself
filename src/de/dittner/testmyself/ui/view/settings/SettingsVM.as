package de.dittner.testmyself.ui.view.settings {
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.async.ProgressCommand;
import de.dittner.ftpClient.FtpClient;
import de.dittner.testmyself.backend.LocalStorage;
import de.dittner.testmyself.backend.LocalStorageKey;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.model.Device;
import de.dittner.testmyself.model.domain.language.Language;
import de.dittner.testmyself.model.domain.language.LanguageID;
import de.dittner.testmyself.model.domain.test.Test;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;
import de.dittner.testmyself.model.domain.vocabulary.VocabularyID;
import de.dittner.testmyself.ui.common.view.ViewModel;
import de.dittner.testmyself.ui.view.settings.components.SettingsInfo;

import flash.events.Event;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

import mx.collections.ArrayCollection;
import mx.resources.ResourceManager;

public class SettingsVM extends ViewModel {
	private static var ftp:FtpClient;

	public function SettingsVM() {
		super();
	}

	[Inject]
	public var storage:Storage;

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	//--------------------------------------
	//  settings
	//--------------------------------------
	private var _settings:SettingsInfo;
	public function get settings():SettingsInfo {return _settings;}

	//--------------------------------------
	//  wordVocabulary
	//--------------------------------------
	private var _wordVocabulary:Vocabulary;
	[Bindable("wordVocabularyChanged")]
	public function get wordVocabulary():Vocabulary {return _wordVocabulary;}
	private function setWordVocabulary(value:Vocabulary):void {
		_wordVocabulary = value;
		dispatchEvent(new Event("wordVocabularyChanged"));
	}

	//--------------------------------------
	//  verbVocabulary
	//--------------------------------------
	private var _verbVocabulary:Vocabulary;
	[Bindable("verbVocabularyChanged")]
	public function get verbVocabulary():Vocabulary {return _verbVocabulary;}
	private function setVerbVocabulary(value:Vocabulary):void {
		_verbVocabulary = value;
		dispatchEvent(new Event("verbVocabularyChanged"));
	}

	//--------------------------------------
	//  lessonVocabulary
	//--------------------------------------
	private var _lessonVocabulary:Vocabulary;
	[Bindable("lessonVocabularyChanged")]
	public function get lessonVocabulary():Vocabulary {return _lessonVocabulary;}
	private function setLessonVocabulary(value:Vocabulary):void {
		if (_lessonVocabulary != value) {
			_lessonVocabulary = value;
			dispatchEvent(new Event("lessonVocabularyChanged"));
		}
	}

	//--------------------------------------
	//  allTestColl
	//--------------------------------------
	private var _allTestColl:ArrayCollection;
	[Bindable("allTestCollChanged")]
	public function get allTestColl():ArrayCollection {return _allTestColl;}
	public function set allTestColl(value:ArrayCollection):void {
		if (_allTestColl != value) {
			_allTestColl = value;
			dispatchEvent(new Event("allTestCollChanged"));
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override public function viewActivated(viewID:String):void {
		super.viewActivated(viewID);
		var lang:Language = appModel.selectedLanguage;
		viewTitle = ResourceManager.getInstance().getString('app', 'SETTINGS');
		if (!ftp) ftp = new FtpClient(Device.stage);
		_settings = LocalStorage.read(LocalStorageKey.SETTINGS_KEY) || new SettingsInfo();
		if (lang.id == LanguageID.DE) {
			setWordVocabulary(lang.vocabularyHash.read(VocabularyID.DE_WORD));
			setVerbVocabulary(lang.vocabularyHash.read(VocabularyID.DE_VERB));
			setLessonVocabulary(lang.vocabularyHash.read(VocabularyID.DE_LESSON));
		}
		else if (lang.id == LanguageID.EN) {
			setWordVocabulary(lang.vocabularyHash.read(VocabularyID.EN_WORD));
			setVerbVocabulary(lang.vocabularyHash.read(VocabularyID.EN_VERB));
			setLessonVocabulary(lang.vocabularyHash.read(VocabularyID.EN_LESSON));
		}

		var allTests:Array = [];
		var test:Test;
		for each(test in wordVocabulary.availableTests) allTests.push(test);
		for each(test in verbVocabulary.availableTests) allTests.push(test);
		for each(test in lessonVocabulary.availableTests) allTests.push(test);
		allTestColl = new ArrayCollection(allTests);
	}

	public function storeSettings(s:SettingsInfo):void {
		_settings = s;
		LocalStorage.write(LocalStorageKey.SETTINGS_KEY, s);
	}

	//--------------------------------------
	//  DB Upload
	//--------------------------------------

	public function uploadDB(info:SettingsInfo):ProgressCommand {
		lockView();
		var noteDBFile:File = File.documentsDirectory.resolvePath(Device.noteDBPath);
		var audioDBFile:File = File.documentsDirectory.resolvePath(Device.audioDBPath);
		var uploadCmd:CompositeCommand = ftp.upload([noteDBFile, audioDBFile], info.backUpServerInfo);
		uploadCmd.addCompleteCallback(uploadDBComplete);
		return uploadCmd;
	}

	private function uploadDBComplete(op:IAsyncOperation):void {
		unlockView();
	}

	//--------------------------------------
	//  DB Download
	//--------------------------------------

	public function downloadDB(info:SettingsInfo):ProgressCommand {
		lockView();
		var tempFolder:File = File.documentsDirectory.resolvePath(Device.dbTempPath);
		if (tempFolder.exists) tempFolder.deleteDirectory(true);
		tempFolder.createDirectory();

		var noteDBFile:File = tempFolder.resolvePath(Device.NOTE_DB_NAME);
		createFile(noteDBFile);

		var audioDBFile:File = tempFolder.resolvePath(Device.AUDIO_DB_NAME);
		createFile(audioDBFile);

		var downloadCmd:CompositeCommand = ftp.download([noteDBFile, audioDBFile], info.backUpServerInfo);
		downloadCmd.addCompleteCallback(downloadDBComplete);
		return downloadCmd;
	}

	private function downloadDBComplete(op:IAsyncOperation):void {
		if (op.isSuccess) reloadDataBase();
		else unlockView();
	}

	private function createFile(file:File):void {
		var stream:FileStream = new FileStream();
		stream.open(file, FileMode.WRITE);
		stream.writeUTFBytes("");
		stream.close();
	}

	private function reloadDataBase():void {
		var appDBFile:File = File.documentsDirectory.resolvePath(Device.APP_NAME);
		if (Device.isDesktop)
			appDBFile.moveToTrash();
		else
			appDBFile.deleteDirectory(true);
		var tempDBFile:File = File.documentsDirectory.resolvePath(Device.TEMP_APP_NAME);
		tempDBFile.moveTo(File.documentsDirectory.resolvePath(Device.APP_NAME));

		var op:IAsyncOperation = storage.reloadDataBase();
		op.addCompleteCallback(dbReloaded);
	}

	private function dbReloaded(op:IAsyncOperation):void {
		var initOp:IAsyncOperation = appModel.selectedLanguage.init();
		initOp.addCompleteCallback(initCompleteHandler);
	}

	private function initCompleteHandler(op:IAsyncOperation):void {
		unlockView();
	}

}
}