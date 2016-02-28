package dittner.testmyself.deutsch.model.settings {
import dittner.ftpClient.utils.ServerInfo;

[RemoteClass(alias="dittner.testmyself.deutsch.model.settings.SettingsInfo")]
public class SettingsInfo {
	public var showTooltip:Boolean = true;
	public var pageSize:uint = 10;
	public var maxAudioRecordDuration:Number = 1;//min
	public var backUpServerInfo:ServerInfo = new ServerInfo();
}
}
