package dittner.testmyself.command.frontend.settings {
import dittner.testmyself.model.common.ITransUnitModel;
import dittner.testmyself.model.settings.SettingsInfo;
import dittner.testmyself.model.settings.SettingsModel;

import mvcexpress.mvc.Command;

public class StoreSettings extends Command {
	[Inject]
	public var settings:SettingsModel;

	[Inject(name='phraseModel')]
	public var model:ITransUnitModel;

	public function execute(info:SettingsInfo):void {
		settings.store(info);
		model.pageInfo = null;
	}
}
}
