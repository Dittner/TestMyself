package de.dittner.testmyself.ui.view.settings.components {
import de.dittner.ftpClient.utils.ServerInfo;

[RemoteClass(alias="de.dittner.testmyself.deutsch.model.settings.SettingsInfo")]
public class SettingsInfo {
	public function SettingsInfo() {
		backUpServerInfo = new ServerInfo();
		backUpServerInfo.user = "dittner";
		backUpServerInfo.host = "dittner.bget.ru";
		backUpServerInfo.remoteDirPath = "dittner.bget.ru/public_html/TestMyself";
	}

	public var maxAudioRecordDuration:Number = 30;//min
	public var backUpServerInfo:ServerInfo;
}
}
