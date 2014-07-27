package dittner.testmyself.command.app {
import dittner.testmyself.command.service.GetDataBaseInfoCmd;
import dittner.testmyself.command.tool.GetPhrasesToolsCmd;
import dittner.testmyself.command.view.GetAllViewInfosCmd;
import dittner.testmyself.command.view.GetSelectedViewCmd;
import dittner.testmyself.message.ServiceMsg;
import dittner.testmyself.message.ToolMsg;
import dittner.testmyself.message.ViewMsg;
import dittner.testmyself.service.helpers.toolFactory.IToolFactory;
import dittner.testmyself.service.helpers.toolFactory.ToolFactory;
import dittner.testmyself.service.helpers.viewFactory.ViewFactory;
import dittner.testmyself.model.language.ILanguage;
import dittner.testmyself.model.language.Language;
import dittner.testmyself.service.DataBaseInfoService;
import dittner.testmyself.view.screen.about.AboutMediator;
import dittner.testmyself.view.screen.about.AboutView;
import dittner.testmyself.service.helpers.viewFactory.IViewFactory;
import dittner.testmyself.view.screen.phrases.PhrasesMediator;
import dittner.testmyself.view.screen.phrases.PhrasesView;
import dittner.testmyself.view.template.TemplateMediator;
import dittner.testmyself.view.template.TemplateView;

import mvcexpress.mvc.Command;

public class ConfigureAppCmd extends Command {

	public function execute(params:Object):void {
		//map commands
		commandMap.map(ViewMsg.GET_SELECTED_VIEW, GetSelectedViewCmd);
		commandMap.map(ViewMsg.GET_ALL_VIEW_INFOS, GetAllViewInfosCmd);
		commandMap.map(ServiceMsg.GET_DATA_BASE_INFO, GetDataBaseInfoCmd);
		commandMap.map(ToolMsg.GET_PHRASES_TOOLS, GetPhrasesToolsCmd);

		//map models and services
		proxyMap.map(createLanguage(), null, ILanguage);
		proxyMap.map(new ViewFactory(), null, IViewFactory);
		proxyMap.map(new ToolFactory(), null, IToolFactory);
		proxyMap.map(new DataBaseInfoService());

		//map views
		mediatorMap.map(AboutView, AboutMediator);
		mediatorMap.map(PhrasesView, PhrasesMediator);
		mediatorMap.map(TemplateView, TemplateMediator);
	}

	private function createLanguage():Language {
		var lang:Language = new Language();
		lang.name = Language.DE;
		return lang;
	}

}
}