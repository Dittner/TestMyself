package dittner.testmyself.command.app {
import dittner.testmyself.command.screen.GenerateScreenCmd;
import dittner.testmyself.command.screen.GetScreenInfoListCmd;
import dittner.testmyself.command.service.GetDataBaseInfoCmd;
import dittner.testmyself.message.ScreenMsg;
import dittner.testmyself.message.ServiceMsg;
import dittner.testmyself.model.phrase.PhraseModel;
import dittner.testmyself.service.DataBaseInfoService;
import dittner.testmyself.service.helpers.deferredComandManager.DeferredCommandManager;
import dittner.testmyself.service.helpers.deferredComandManager.IDeferredCommandManager;
import dittner.testmyself.service.helpers.screenFactory.IScreenFactory;
import dittner.testmyself.service.helpers.screenFactory.ScreenFactory;
import dittner.testmyself.service.phrase.PhraseService;
import dittner.testmyself.view.about.AboutScreen;
import dittner.testmyself.view.about.AboutScreenMediator;
import dittner.testmyself.view.phrase.PhraseScreen;
import dittner.testmyself.view.phrase.PhraseScreenMediator;
import dittner.testmyself.view.template.TemplateMediator;
import dittner.testmyself.view.template.TemplateScreen;

import mvcexpress.mvc.Command;

public class ConfigureAppCmd extends Command {

	public function execute(params:Object):void {
		//map commands
		commandMap.map(ScreenMsg.GENERATE_SCREEN, GenerateScreenCmd);
		commandMap.map(ScreenMsg.GET_SCREEN_INFO_LIST, GetScreenInfoListCmd);
		commandMap.map(ServiceMsg.GET_DATA_BASE_INFO, GetDataBaseInfoCmd);

		commandMap.execute(SetupPhraseCommands);

		//map models and services
		proxyMap.map(new DeferredCommandManager(), null, IDeferredCommandManager);
		proxyMap.map(new ScreenFactory(), null, IScreenFactory);
		proxyMap.map(new PhraseModel(), null, PhraseModel);
		proxyMap.map(new DataBaseInfoService());
		proxyMap.map(new PhraseService());

		//map views
		mediatorMap.map(AboutScreen, AboutScreenMediator);
		mediatorMap.map(PhraseScreen, PhraseScreenMediator);
		mediatorMap.map(TemplateScreen, TemplateMediator);
	}

}
}