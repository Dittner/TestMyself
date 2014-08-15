package dittner.testmyself.command.app {
import dittner.testmyself.command.frontend.screen.GenerateScreenCmd;
import dittner.testmyself.command.frontend.screen.GetScreenInfoListCmd;
import dittner.testmyself.command.frontend.settings.LoadSettings;
import dittner.testmyself.command.frontend.settings.StoreSettings;
import dittner.testmyself.command.operation.deferredOperation.DeferredOperationManager;
import dittner.testmyself.command.operation.deferredOperation.IDeferredOperationManager;
import dittner.testmyself.message.ScreenMsg;
import dittner.testmyself.message.SettingsMsg;
import dittner.testmyself.model.common.SettingsModel;
import dittner.testmyself.model.phrase.PhraseModel;
import dittner.testmyself.service.PhraseService;
import dittner.testmyself.service.screenFactory.IScreenFactory;
import dittner.testmyself.service.screenFactory.ScreenFactory;
import dittner.testmyself.view.about.AboutScreen;
import dittner.testmyself.view.about.AboutScreenMediator;
import dittner.testmyself.view.common.tooltip.CustomToolTipManager;
import dittner.testmyself.view.phrase.PhraseScreen;
import dittner.testmyself.view.phrase.PhraseScreenMediator;
import dittner.testmyself.view.settings.SettingsMediator;
import dittner.testmyself.view.settings.SettingsScreen;
import dittner.testmyself.view.template.TemplateMediator;
import dittner.testmyself.view.template.TemplateScreen;

import mvcexpress.mvc.Command;

public class ConfigureAppCmd extends Command {

	public function execute(params:Object):void {
		//map commands
		commandMap.map(ScreenMsg.GENERATE_SCREEN, GenerateScreenCmd);
		commandMap.map(ScreenMsg.GET_SCREEN_INFO_LIST, GetScreenInfoListCmd);
		commandMap.map(SettingsMsg.LOAD, LoadSettings);
		commandMap.map(SettingsMsg.STORE, StoreSettings);
		commandMap.execute(SetupPhraseCommands);

		//map models and services
		proxyMap.map(new DeferredOperationManager(), null, IDeferredOperationManager);
		proxyMap.map(new ScreenFactory(), null, IScreenFactory);
		proxyMap.map(new PhraseModel(), null, PhraseModel);
		proxyMap.map(new PhraseService());
		proxyMap.map(new SettingsModel());
		proxyMap.map(new CustomToolTipManager());

		//map views
		mediatorMap.map(AboutScreen, AboutScreenMediator);
		mediatorMap.map(PhraseScreen, PhraseScreenMediator);
		mediatorMap.map(SettingsScreen, SettingsMediator);
		mediatorMap.map(TemplateScreen, TemplateMediator);
	}

}
}