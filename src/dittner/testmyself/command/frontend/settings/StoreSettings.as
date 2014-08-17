package dittner.testmyself.command.frontend.settings {
import dittner.testmyself.model.common.SettingsInfo;
import dittner.testmyself.model.common.SettingsModel;
import dittner.testmyself.model.phrase.PhraseModel;

import mvcexpress.mvc.Command;

public class StoreSettings extends Command {
	[Inject]
	public var model:SettingsModel;

	[Inject]
	public var phraseModel:PhraseModel;

	public function execute(info:SettingsInfo):void {
		model.store(info);
		phraseModel.pageInfo = null;
	}
}
}
