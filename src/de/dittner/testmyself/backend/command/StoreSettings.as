package de.dittner.testmyself.backend.command {
import de.dittner.testmyself.model.settings.SettingsInfo;
import de.dittner.testmyself.model.settings.SettingsModel;

public class StoreSettings implements ISFCommand {

	[Inject]
	public var settingsModel:SettingsModel;

	public function execute(msg:IRequestMessage):void {
		settingsModel.store(msg.data as SettingsInfo);
	}
}
}
