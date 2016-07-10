package de.dittner.testmyself.ui.view.settings {
import de.dittner.async.CompositeCommand;
import de.dittner.async.IAsyncOperation;
import de.dittner.async.utils.doLaterInMSec;
import de.dittner.ftpClient.FtpClient;
import de.dittner.satelliteFlight.mediator.SFMediator;
import de.dittner.satelliteFlight.message.RequestMessage;
import de.dittner.testmyself.TestMyselfApp;
import de.dittner.testmyself.backend.message.NoteMsg;
import de.dittner.testmyself.model.AppConfig;
import de.dittner.testmyself.model.ModuleName;
import de.dittner.testmyself.model.settings.SettingsInfo;
import de.dittner.testmyself.ui.message.ScreenMsg;
import de.dittner.testmyself.ui.message.SettingsMsg;
import de.dittner.testmyself.ui.view.settings.noteSettings.LessonSettingsMediator;
import de.dittner.testmyself.ui.view.settings.noteSettings.VerbSettingsMediator;
import de.dittner.testmyself.ui.view.settings.noteSettings.WordSettingsMediator;
import de.dittner.testmyself.ui.view.settings.testSettings.TestSettingsMediator;

import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

public class SettingsScreenMediator extends SFMediator {

	[Inject]
	public var view:SettingsScreen;

	private static var ftp:FtpClient;

	override protected function activate():void {
		sendRequest(ScreenMsg.LOCK, new RequestMessage());
		doLaterInMSec(preActivation, 500);
	}

	private function preActivation():void {
		activateScreen();
		sendRequest(ScreenMsg.UNLOCK, new RequestMessage());
	}

	private function activateScreen():void {
		view.activate();
		if (!ftp) ftp = new FtpClient(TestMyselfApp.stage);
		sendRequest(SettingsMsg.LOAD, new RequestMessage(infoLoaded));
		registerMediator(view.wordSettings, new WordSettingsMediator());
		registerMediator(view.verbSettings, new VerbSettingsMediator());
		registerMediator(view.lessonSettings, new LessonSettingsMediator());
		registerMediator(view.testSettings, new TestSettingsMediator());
		view.commonSettings.uploadBtn.addEventListener(MouseEvent.CLICK, uploadBtnClicked);
		view.commonSettings.downloadBtn.addEventListener(MouseEvent.CLICK, downloadBtnClicked);
	}

	private function infoLoaded(op:IAsyncOperation):void {
		var info:SettingsInfo = op.result as SettingsInfo;
		view.commonSettings.showTooltipBox.selected = info.showTooltip;
		view.commonSettings.maxAudioRecordDurationSpinner.value = info.maxAudioRecordDuration;
		view.commonSettings.pageSizeSpinner.value = info.pageSize;
		view.commonSettings.hostInput.text = info.backUpServerInfo.host;
		view.commonSettings.portInput.text = info.backUpServerInfo.port.toString();
		view.commonSettings.userNameInput.text = info.backUpServerInfo.user;
		view.commonSettings.pwdInput.text = info.backUpServerInfo.password;
		view.commonSettings.remoteDirInput.text = info.backUpServerInfo.remoteDirPath;
	}

	//--------------------------------------
	//  upload data base
	//--------------------------------------

	private function uploadBtnClicked(event:MouseEvent):void {
		sendRequest(ScreenMsg.LOCK, new RequestMessage());
		view.commonSettings.isUploading = true;
		view.commonSettings.progressBar.visible = true;
		view.commonSettings.errorText = "";
		view.commonSettings.isDataBaseTransferOperationSuccess = false;
		var info:SettingsInfo = storeSettings();
		uploadDataBase(info);
	}

	private function uploadDataBase(info:SettingsInfo):void {
		var wordDbFile:File = File.documentsDirectory.resolvePath(AppConfig.dbRootPath + ModuleName.WORD + ".db");
		var lessonDbFile:File = File.documentsDirectory.resolvePath(AppConfig.dbRootPath + ModuleName.LESSON + ".db");
		var verbDbFile:File = File.documentsDirectory.resolvePath(AppConfig.dbRootPath + ModuleName.VERB + ".db");

		var uploadCmd:CompositeCommand = ftp.upload([wordDbFile, lessonDbFile, verbDbFile], info.backUpServerInfo);
		uploadCmd.addCompleteCallback(uploadComplete);
		uploadCmd.addProgressCallback(uploadProgress);
	}

	private function uploadProgress(value:Number):void {
		view.commonSettings.progressBar.progress = value;
	}

	private function uploadComplete(op:IAsyncOperation):void {
		sendRequest(ScreenMsg.UNLOCK, new RequestMessage());

		if (op.isSuccess) {
			view.commonSettings.isDataBaseTransferOperationSuccess = true;
		}
		else {
			view.commonSettings.errorText = "Error: " + op.error;
			view.commonSettings.isDataBaseTransferOperationSuccess = false;
		}
		view.commonSettings.progressBar.visible = false;
	}

	//--------------------------------------
	//  download data base
	//--------------------------------------

	private function downloadBtnClicked(event:MouseEvent):void {
		sendRequest(ScreenMsg.LOCK, new RequestMessage());
		view.commonSettings.isUploading = false;
		view.commonSettings.progressBar.visible = true;
		view.commonSettings.errorText = "";
		view.commonSettings.isDataBaseTransferOperationSuccess = false;
		var info:SettingsInfo = storeSettings();
		downloadDataBase(info);
	}

	private function downloadDataBase(info:SettingsInfo):void {
		var tempFolder:File = File.documentsDirectory.resolvePath(AppConfig.dbTempPath);
		if (tempFolder.exists) tempFolder.deleteDirectory(true);
		tempFolder.createDirectory();

		var wordDbFile:File = tempFolder.resolvePath(ModuleName.WORD + ".db");
		createFile(wordDbFile);
		var lessonDbFile:File = tempFolder.resolvePath(ModuleName.LESSON + ".db");
		createFile(lessonDbFile);
		var verbDbFile:File = tempFolder.resolvePath(ModuleName.VERB + ".db");
		createFile(verbDbFile);

		var downloadCmd:CompositeCommand = ftp.download([wordDbFile, lessonDbFile, verbDbFile], info.backUpServerInfo);
		downloadCmd.addCompleteCallback(downloadComplete);
		downloadCmd.addProgressCallback(downloadProgress);
	}

	private function createFile(file:File):void {
		var stream:FileStream = new FileStream();
		stream.open(file, FileMode.WRITE);
		stream.writeUTFBytes("");
		stream.close();
	}

	private function downloadProgress(value:Number):void {
		view.commonSettings.progressBar.progress = value;
	}

	private function downloadComplete(op:IAsyncOperation):void {
		if (op.isSuccess) {
			view.commonSettings.isDataBaseTransferOperationSuccess = true;
			reloadDataBase();
		}
		else {
			view.commonSettings.errorText = "Error: " + op.error;
			view.commonSettings.isDataBaseTransferOperationSuccess = false;
			sendRequest(ScreenMsg.UNLOCK, new RequestMessage());
		}
		view.commonSettings.progressBar.visible = false;
	}

	private var dbNum:int = 0;
	private function reloadDataBase():void {
		dbNum = 3;
		var appDBFile:File = File.documentsDirectory.resolvePath(AppConfig.APP_NAME);
		if (AppConfig.isDesktop)
			appDBFile.moveToTrash();
		else
			appDBFile.deleteDirectory(true);
		var tempDBFile:File = File.documentsDirectory.resolvePath(AppConfig.TEMP_APP_NAME);
		tempDBFile.moveTo(File.documentsDirectory.resolvePath(AppConfig.APP_NAME));

		sendRequestTo(ModuleName.WORD, SettingsMsg.RELOAD_DB, new RequestMessage(dbReloaded));
		sendRequestTo(ModuleName.VERB, SettingsMsg.RELOAD_DB, new RequestMessage(dbReloaded));
		sendRequestTo(ModuleName.LESSON, SettingsMsg.RELOAD_DB, new RequestMessage(dbReloaded));
	}

	private function dbReloaded(op:IAsyncOperation):void {
		dbNum--;
		if (dbNum == 0)
			sendRequest(ScreenMsg.UNLOCK, new RequestMessage());
	}

	private function storeSettings():SettingsInfo {
		var info:SettingsInfo = new SettingsInfo();
		info.showTooltip = view.commonSettings.showTooltipBox.selected;
		info.maxAudioRecordDuration = view.commonSettings.maxAudioRecordDurationSpinner.value;
		info.pageSize = view.commonSettings.pageSizeSpinner.value;
		info.backUpServerInfo.host = view.commonSettings.hostInput.text;
		info.backUpServerInfo.port = int(view.commonSettings.portInput.text);
		info.backUpServerInfo.user = view.commonSettings.userNameInput.text;
		info.backUpServerInfo.password = view.commonSettings.pwdInput.text;
		info.backUpServerInfo.remoteDirPath = view.commonSettings.remoteDirInput.text;

		sendRequest(SettingsMsg.STORE, new RequestMessage(null, info));

		return info;
	}

	override protected function deactivate():void {
		view.clear();
		storeSettings();
		sendRequestTo(ModuleName.WORD, NoteMsg.CLEAR_NOTES_INFO, new RequestMessage());
		sendRequestTo(ModuleName.VERB, NoteMsg.CLEAR_NOTES_INFO, new RequestMessage());
		view.commonSettings.uploadBtn.removeEventListener(MouseEvent.CLICK, uploadBtnClicked);
		view.commonSettings.downloadBtn.removeEventListener(MouseEvent.CLICK, downloadBtnClicked);
	}

}
}