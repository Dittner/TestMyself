package de.dittner.testmyself.ui.view.settings {
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.async.ProgressCommand;
import de.dittner.ftpClient.FtpClient;
import de.dittner.testmyself.backend.LocalStorage;
import de.dittner.testmyself.backend.SharedObjectStorage;
import de.dittner.testmyself.backend.Storage;
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

	public function storeSettings(s:SettingsInfo):void {
		_settings = s;
		LocalStorage.write(SETTINGS_KEY, s);
	}

	//--------------------------------------
	//  DB Upload
	//--------------------------------------

	public function uploadDB(info:SettingsInfo):ProgressCommand {
		lockView();
		var dbFile:File = File.documentsDirectory.resolvePath(Device.dbPath);
		var uploadCmd:CompositeCommand = ftp.upload([dbFile], info.backUpServerInfo);
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

		var dbFile:File = tempFolder.resolvePath(Device.DB_NAME);
		createFile(dbFile);

		var downloadCmd:CompositeCommand = ftp.download([dbFile], info.backUpServerInfo);
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

	//--------------------------------------
	//  DB in SO Parsing
	//--------------------------------------

	private static var soStorage:SharedObjectStorage;
	public function parseDBFromSO():void {
		if (!soStorage) {
			soStorage = new SharedObjectStorage();
			soStorage.init("dataBase");
		}
		var composite:CompositeCommand = new CompositeCommand();

		composite.addOperation(ParseDBFromSO, storage, wordVocabulary, soStorage.getObject("word"));
		composite.addOperation(ParseDBFromSO, storage, verbVocabulary, soStorage.getObject("verb"));
		composite.addOperation(ParseDBFromSO, storage, lessonVocabulary, soStorage.getObject("lesson"));

		composite.execute();
	}

}
}

import de.dittner.async.IAsyncCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.Storage;
import de.dittner.testmyself.backend.op.StorageOperation;
import de.dittner.testmyself.model.domain.note.DeVerb;
import de.dittner.testmyself.model.domain.note.DeWord;
import de.dittner.testmyself.model.domain.note.Note;
import de.dittner.testmyself.model.domain.theme.Theme;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;

class ParseDBFromSO extends StorageOperation implements IAsyncCommand {
	public function ParseDBFromSO(storage:Storage, vocabulary:Vocabulary, data:Object) {
		super();
		this.storage = storage;
		this.vocabulary = vocabulary;
		this.data = data;
	}

	private var storage:Storage;
	private var vocabulary:Vocabulary;
	private var data:Object;

	public function execute():void {
		parseThemes();
	}

	private var newThemeHash:Object = {};//by old themeID
	private var themes:Array;
	private function parseThemes():void {
		themes = data.themes.concat();
		storeNextTheme();
	}

	private function storeNextTheme(op:IAsyncOperation = null):void {
		if (themes.length > 0) {
			var themeData:Object = themes.pop();
			var t:Theme = vocabulary.createTheme();
			newThemeHash[themeData.id] = t;
			t.name = themeData.name;
			t.store().addCompleteCallback(storeNextTheme);
		}
		else {
			prepareNotes();
			storeNotes();
		}
	}

	private var notes:Array = [];
	private var exampleHash:Object = {};//by noteID
	private var filterHash:Object = {};//by noteID
	private function prepareNotes():void {
		var exampleItem:Object;
		var filterItem:Object;

		for each(exampleItem in data.examples) {
			if (!exampleHash[exampleItem.noteID])
				exampleHash[exampleItem.noteID] = [];
			exampleHash[exampleItem.noteID].push(exampleItem);
		}

		for each(filterItem in data.filters) {
			if (!filterHash[filterItem.noteID])
				filterHash[filterItem.noteID] = [];
			filterHash[filterItem.noteID].push(filterItem.themeID);
		}

		for each(var noteItem:Object in data.note) {
			var note:Note = vocabulary.createNote();
			note.title = noteItem.title;
			note.description = noteItem.description;
			if (note is DeWord) {
				(note as DeWord).article = noteItem.article;
				(note as DeWord).declension = noteItem.options;
			}
			else if (note is DeVerb) {
				(note as DeVerb).past = noteItem.past;
				(note as DeVerb).perfect = noteItem.perfect;
				(note as DeVerb).present = noteItem.present;
			}

			if (noteItem.bytes) {
				note.audioComment.bytes = noteItem.bytes;
				note.audioComment.isMp3 = true;
			}

			if (exampleHash[noteItem.id])
				for each(exampleItem in exampleHash[noteItem.id]) {
					var example:Note = note.createExample();
					example.title = exampleItem.title;
					example.description = exampleItem.description;
					if (exampleItem.bytes) {
						example.audioComment.bytes = exampleItem.bytes;
						example.audioComment.isMp3 = true;
					}
					note.exampleColl.addItem(example);
				}

			if (filterHash[noteItem.id]) {
				for each(var themeID:String in filterHash[noteItem.id]) {
					var theme:Theme = newThemeHash[themeID];
					if (theme) {
						note.themes.push(theme);
					}
					else {
						trace("No theme!");
					}
				}
			}
			notes.push(note);
		}

	}

	private function storeNotes():void {
		var op:IAsyncOperation;
		for each(var note:Note in notes)
			op = note.store();
		op.addCompleteCallback(notesStored);
	}

	private function notesStored(op:IAsyncOperation):void {
		if (op.isSuccess) dispatchSuccess();
		else dispatchError(op.error);
	}
}