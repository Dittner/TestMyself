package dittner.testmyself.command.app {
import dittner.testmyself.command.phrase.ClearPhraseModelCmd;
import dittner.testmyself.command.phrase.GetPhrasesCmd;
import dittner.testmyself.command.phrase.GetSelectedPhraseCmd;
import dittner.testmyself.command.phrase.GetThemesForPhraseCmd;
import dittner.testmyself.command.phrase.SelectPhraseCmd;
import dittner.testmyself.command.screen.GetScreenInfoListCmd;
import dittner.testmyself.command.screen.GetSelectedScreenViewCmd;
import dittner.testmyself.command.screen.SelectScreenCmd;
import dittner.testmyself.command.service.GetDataBaseInfoCmd;
import dittner.testmyself.message.PhraseMsg;
import dittner.testmyself.message.ScreenMsg;
import dittner.testmyself.message.ServiceMsg;
import dittner.testmyself.model.MainModel;
import dittner.testmyself.model.phrase.PhraseModel;
import dittner.testmyself.service.DataBaseInfoService;
import dittner.testmyself.service.PhraseService;
import dittner.testmyself.service.helpers.screenFactory.IScreenFactory;
import dittner.testmyself.service.helpers.screenFactory.ScreenFactory;
import dittner.testmyself.view.about.AboutScreenMediator;
import dittner.testmyself.view.about.AboutScreen;
import dittner.testmyself.view.phrase.PhraseScreen;
import dittner.testmyself.view.phrase.PhraseScreenMediator;
import dittner.testmyself.view.template.TemplateMediator;
import dittner.testmyself.view.template.TemplateScreen;

import mvcexpress.mvc.Command;

public class ConfigureAppCmd extends Command {

	public function execute(params:Object):void {
		//map commands
		commandMap.map(ScreenMsg.GET_SELECTED_SCREEN_VIEW, GetSelectedScreenViewCmd);
		commandMap.map(ScreenMsg.GET_SCREEN_INFO_LIST, GetScreenInfoListCmd);
		commandMap.map(ScreenMsg.SELECT_SCREEN, SelectScreenCmd);
		commandMap.map(ServiceMsg.GET_DATA_BASE_INFO, GetDataBaseInfoCmd);
		//-------------------- PHRASE ------------------
		commandMap.map(PhraseMsg.SELECT_PHRASE, SelectPhraseCmd);
		commandMap.map(PhraseMsg.CLEAR_MODEL, ClearPhraseModelCmd);
		commandMap.map(PhraseMsg.GET_THEMES, GetThemesForPhraseCmd);
		commandMap.map(PhraseMsg.GET_PHRASES, GetPhrasesCmd);
		commandMap.map(PhraseMsg.GET_SELECTED_PHRASE, GetSelectedPhraseCmd);

		//map models and services
		proxyMap.map(new ScreenFactory(), null, IScreenFactory);
		proxyMap.map(new MainModel(), null, MainModel);
		proxyMap.map(new PhraseModel(), null, PhraseModel);
		proxyMap.map(new PhraseService());
		proxyMap.map(new DataBaseInfoService());

		//map views
		mediatorMap.map(AboutScreen, AboutScreenMediator);
		mediatorMap.map(PhraseScreen, PhraseScreenMediator);
		mediatorMap.map(TemplateScreen, TemplateMediator);
	}

}
}