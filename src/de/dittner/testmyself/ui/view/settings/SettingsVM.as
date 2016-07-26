package de.dittner.testmyself.ui.view.settings {
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.async.ProgressCommand;
import de.dittner.ftpClient.FtpClient;
import de.dittner.testmyself.backend.LocalStorage;
import de.dittner.testmyself.backend.SQLStorage;
import de.dittner.testmyself.model.AppModel;
import de.dittner.testmyself.model.Device;
import de.dittner.testmyself.model.domain.test.Test;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;
import de.dittner.testmyself.model.domain.vocabulary.VocabularyID;
import de.dittner.testmyself.ui.common.view.ViewInfo;
import de.dittner.testmyself.ui.common.view.ViewModel;
import de.dittner.testmyself.ui.view.settings.components.SettingsInfo;

import flash.events.Event;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

import mx.collections.ArrayCollection;

public class SettingsVM extends ViewModel {
	private static const SETTINGS_KEY:String = "SETTINGS_KEY";
	private static var ftp:FtpClient;

	public function SettingsVM() {
		super();
	}

	[Inject]
	public var appModel:AppModel;
	[Inject]
	public var storage:SQLStorage;

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

	override public function viewActivated(info:ViewInfo):void {
		super.viewActivated(info);
		if (!ftp) ftp = new FtpClient(Device.stage);
		_settings = LocalStorage.read(SETTINGS_KEY) || new SettingsInfo();
		setWordVocabulary(appModel.selectedLanguage.vocabularyHash.read(VocabularyID.DE_WORD));
		setVerbVocabulary(appModel.selectedLanguage.vocabularyHash.read(VocabularyID.DE_VERB));
		setLessonVocabulary(appModel.selectedLanguage.vocabularyHash.read(VocabularyID.DE_LESSON));

		var allTests:Array = [];
		var test:Test;
		for each(test in wordVocabulary.availableTests) allTests.push(test);
		for each(test in verbVocabulary.availableTests) allTests.push(test);
		for each(test in lessonVocabulary.availableTests) allTests.push(test);
		allTestColl = new ArrayCollection(allTests);
	}

	public function uploadDB(info:SettingsInfo):ProgressCommand {
		var dbFile:File = File.documentsDirectory.resolvePath(Device.dbPath);
		var uploadCmd:CompositeCommand = ftp.upload([dbFile], info.backUpServerInfo);
		return uploadCmd;
	}

	public function downloadDB(info:SettingsInfo):ProgressCommand {
		var tempFolder:File = File.documentsDirectory.resolvePath(Device.dbTempPath);
		if (tempFolder.exists) tempFolder.deleteDirectory(true);
		tempFolder.createDirectory();

		var dbFile:File = tempFolder.resolvePath(Device.DB_NAME);
		createFile(dbFile);

		var downloadCmd:CompositeCommand = ftp.download([dbFile], info.backUpServerInfo);
		downloadCmd.addCompleteCallback(downloadDBComplete);
		return downloadCmd;
	}

	private function downloadDBComplete(op:IAsyncOperation):void {
		if (op.isSuccess) {
			reloadDataBase();
		}
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

		storage.reloadDataBase();
	}

	public function storeSettings(s:SettingsInfo):void {
		_settings = s;
		LocalStorage.write(SETTINGS_KEY, s);
	}

	override protected function deactivate():void {}

}
}