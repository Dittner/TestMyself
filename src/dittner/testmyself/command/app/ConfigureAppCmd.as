package dittner.testmyself.command.app {
import dittner.testmyself.command.screen.GetScreenInfoListCmd;
import dittner.testmyself.command.screen.GetSelectedScreenViewCmd;
import dittner.testmyself.command.screen.NotifySelectedScreenChangedCmd;
import dittner.testmyself.command.service.GetDataBaseInfoCmd;
import dittner.testmyself.command.tool.GetToolsForPhraseCmd;
import dittner.testmyself.message.ScreenMsg;
import dittner.testmyself.message.ServiceMsg;
import dittner.testmyself.message.ToolMsg;
import dittner.testmyself.model.MainModel;
import dittner.testmyself.model.language.ILanguage;
import dittner.testmyself.model.language.Language;
import dittner.testmyself.model.phrase.PhraseModel;
import dittner.testmyself.service.DataBaseInfoService;
import dittner.testmyself.service.helpers.screenFactory.IScreenFactory;
import dittner.testmyself.service.helpers.screenFactory.ScreenFactory;
import dittner.testmyself.service.helpers.toolFactory.IToolFactory;
import dittner.testmyself.service.helpers.toolFactory.ToolFactory;
import dittner.testmyself.view.screen.about.AboutMediator;
import dittner.testmyself.view.screen.about.AboutView;
import dittner.testmyself.view.screen.phrase.PhraseMediator;
import dittner.testmyself.view.screen.phrase.PhraseView;
import dittner.testmyself.view.template.TemplateMediator;
import dittner.testmyself.view.template.TemplateView;

import mvcexpress.mvc.Command;

public class ConfigureAppCmd extends Command {

	public function execute(params:Object):void {
		//map commands
		commandMap.map(ScreenMsg.GET_SELECTED_SCREEN_VIEW, GetSelectedScreenViewCmd);
		commandMap.map(ScreenMsg.GET_SCREEN_INFO_LIST, GetScreenInfoListCmd);
		commandMap.map(ScreenMsg.NOTIFY_SELECTED_SCREEN_CHANGED, NotifySelectedScreenChangedCmd);
		commandMap.map(ServiceMsg.GET_DATA_BASE_INFO, GetDataBaseInfoCmd);
		commandMap.map(ToolMsg.GET_TOOLS_FOR_PHRASE, GetToolsForPhraseCmd);

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