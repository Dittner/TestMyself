package dittner.testmyself.command.app {
import dittner.testmyself.command.phrase.GetToolsForPhraseCmd;
import dittner.testmyself.command.phrase.SelectPhraseToolCmd;
import dittner.testmyself.command.screen.GetScreenInfoListCmd;
import dittner.testmyself.command.screen.GetSelectedScreenViewCmd;
import dittner.testmyself.command.screen.SelectScreenCmd;
import dittner.testmyself.command.service.GetDataBaseInfoCmd;
import dittner.testmyself.message.PhraseMsg;
import dittner.testmyself.message.ScreenMsg;
import dittner.testmyself.message.ServiceMsg;
import dittner.testmyself.model.MainModel;
import dittner.testmyself.model.language.ILanguage;
import dittner.testmyself.model.language.Language;
import dittner.testmyself.model.phrase.PhraseModel;
import dittner.testmyself.service.DataBaseInfoService;
import dittner.testmyself.service.helpers.screenFactory.IScreenFactory;
import dittner.testmyself.service.helpers.screenFactory.ScreenFactory;
import dittner.testmyself.service.helpers.toolFactory.IToolFactory;
import dittner.testmyself.service.helpers.toolFactory.ToolFactory;
import dittner.testmyself.view.about.AboutMediator;
import dittner.testmyself.view.about.AboutView;
import dittner.testmyself.view.phrase.PhraseMediator;
import dittner.testmyself.view.phrase.PhraseView;
import dittner.testmyself.view.template.TemplateMediator;
import dittner.testmyself.view.template.TemplateView;

import mvcexpress.mvc.Command;

public class ConfigureAppCmd extends Command {

	public function execute(params:Object):void {
		//map commands
		commandMap.map(ScreenMsg.GET_SELECTED_SCREEN_VIEW, GetSelectedScreenViewCmd);
		commandMap.map(ScreenMsg.GET_SCREEN_INFO_LIST, GetScreenInfoListCmd);
		commandMap.map(ScreenMsg.SELECT_SCREEN, SelectScreenCmd);
		commandMap.map(ServiceMsg.GET_DATA_BASE_INFO, GetDataBaseInfoCmd);
		//-------------------- PHRASE ------------------
		commandMap.map(PhraseMsg.GET_TOOLS, GetToolsForPhraseCmd);
		commandMap.map(PhraseMsg.SELECT_TOOL, SelectPhraseToolCmd);

		//map models and services
		proxyMap.map(createLanguage(), null, ILanguage);
		proxyMap.map(new ScreenFactory(), null, IScreenFactory);
		proxyMap.map(new ToolFactory(), null, IToolFactory);
		proxyMap.map(new MainModel(), null, MainModel);
		proxyMap.map(new PhraseModel(), null, PhraseModel);
		proxyMap.map(new DataBaseInfoService());

		//map views
		mediatorMap.map(AboutView, AboutMediator);
		mediatorMap.map(PhraseView, PhraseMediator);
		mediatorMap.map(TemplateView, TemplateMediator);
	}

	private function createLanguage():Language {
		var lang:Language = new Language();
		lang.name = Language.DE;
		return lang;
	}

}
}