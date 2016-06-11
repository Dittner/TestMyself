package dittner.testmyself.deutsch.model.settings {
import de.dittner.ftpClient.utils.ServerInfo;

[RemoteClass(alias="dittner.testmyself.deutsch.model.settings.SettingsInfo")]
public class SettingsInfo {
	public function SettingsInfo() {
		backUpServerInfo = new ServerInfo();
		backUpServerInfo.user = "dittner";
		backUpServerInfo.host = "dittner.bget.ru";
		backUpServerInfo.remoteDirPath = "dittner.bget.ru/public_html/TestMyself/deutsch";
	}

	public var showTooltip:Boolean = false;
	public var pageSize:uint = 10;
	public var maxAudioRecordDuration:Number = 30;//min
	public var backUpServerInfo:ServerInfo;
}
}
