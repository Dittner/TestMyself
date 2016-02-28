package dittner.testmyself.deutsch.view.settings {
import dittner.async.CompositeCommand;
import dittner.async.IAsyncOperation;
import dittner.ftpClient.FtpClient;
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.message.RequestMessage;
import dittner.testmyself.TestMyselfApp;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.deutsch.message.SettingsMsg;
import dittner.testmyself.deutsch.model.AppConfig;
import dittner.testmyself.deutsch.model.ModuleName;
import dittner.testmyself.deutsch.model.settings.SettingsInfo;
import dittner.testmyself.deutsch.view.settings.noteSettings.LessonSettingsMediator;
import dittner.testmyself.deutsch.view.settings.noteSettings.VerbSettingsMediator;
import dittner.testmyself.deutsch.view.settings.noteSettings.WordSettingsMediator;
import dittner.testmyself.deutsch.view.settings.testSettings.TestSettingsMediator;

import flash.events.MouseEvent;
import flash.filesystem.File;

public class SettingsScreenMediator extends SFMediator {

	[Inject]
	public var view:SettingsScreen;

	private static var ftp:FtpClient;

	override protected function activate():void {
		if (!ftp) ftp = new FtpClient(TestMyselfApp.stage);
		view.clear();
		sendRequest(SettingsMsg.LOAD, new RequestMessage(infoLoaded));
		registerMediator(view.wordSettings, new WordSettingsMediator());
		registerMediator(view.verbSettings, new VerbSettingsMediator());
		registerMediator(view.lessonSettings, new LessonSettingsMediator());
		registerMediator(view.testSettings, new TestSettingsMediator());
		view.commonSettings.copySendBtn.addEventListener(MouseEvent.CLICK, sendCopyClicked);
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

	private function sendCopyClicked(event:MouseEvent):void {
		view.commonSettings.progressBar.visible = true;
		view.commonSettings.errorText = "";
		view.commonSettings.isUploadSuccess = false;
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
		if (op.isSuccess) {
			view.commonSettings.isUploadSuccess = true;
		}
		else {
			view.commonSettings.errorText = "Error: " + op.error;
			view.commonSettings.isUploadSuccess = false;
		}
		view.commonSettings.progressBar.visible = false;
	}

	override protected function deactivate():void {
		storeSettings();
		sendRequestTo(ModuleName.WORD, NoteMsg.CLEAR_NOTES_INFO, new RequestMessage());
		sendRequestTo(ModuleName.VERB, NoteMsg.CLEAR_NOTES_INFO, new RequestMessage());
		view.commonSettings.copySendBtn.removeEventListener(MouseEvent.CLICK, sendCopyClicked);
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

}
}