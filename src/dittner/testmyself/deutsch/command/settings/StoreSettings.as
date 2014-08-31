package dittner.testmyself.deutsch.command.settings {
import dittner.satelliteFlight.command.ISFCommand;
import dittner.satelliteFlight.message.IRequestMessage;
import dittner.testmyself.deutsch.model.settings.SettingsInfo;
import dittner.testmyself.deutsch.model.settings.SettingsModel;

public class StoreSettings implements ISFCommand {

	[Inject]
	public var settingsModel:SettingsModel;

	public function execute(msg:IRequestMessage):void {
		settingsModel.store(msg.data as SettingsInfo);
	}
}
}
