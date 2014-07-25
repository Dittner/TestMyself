package dittner.testmyself.command.app {
import dittner.testmyself.command.service.GetDataBaseInfoCmd;
import dittner.testmyself.command.view.GetAllViewInfosCmd;
import dittner.testmyself.command.view.GetSelectedViewCmd;
import dittner.testmyself.message.DataBaseInfoMsg;
import dittner.testmyself.message.ViewMsg;
import dittner.testmyself.model.ViewFactory;
import dittner.testmyself.model.language.ILanguage;
import dittner.testmyself.model.language.Language;
import dittner.testmyself.model.phrases.PhrasesModel;
import dittner.testmyself.service.DataBaseInfoService;
import dittner.testmyself.view.about.AboutMediator;
import dittner.testmyself.view.about.AboutView;
import dittner.testmyself.view.core.IViewFactory;
import dittner.testmyself.view.template.TemplateMediator;
import dittner.testmyself.view.template.TemplateView;

import mvcexpress.mvc.Command;

public class ConfigureAppCmd extends Command {

	public function execute(params:Object):void {
		//map commands
		commandMap.map(ViewMsg.GET_SELECTED_VIEW, GetSelectedViewCmd);
		commandMap.map(ViewMsg.GET_ALL_VIEW_INFOS, GetAllViewInfosCmd);
		commandMap.map(DataBaseInfoMsg.GET_DATA_BASE_INFO, GetDataBaseInfoCmd);

		//map models
		proxyMap.map(createLanguage(), null, ILanguage);
		proxyMap.map(new ViewFactory(), null, IViewFactory);
		proxyMap.map(new DataBaseInfoService());
		proxyMap.map(new PhrasesModel());
		mediatorMap.map(TemplateView, TemplateMediator);

		//map views
		mediatorMap.map(AboutView, AboutMediator);
	}

	private function createLanguage():Language {
		var lang:Language = new Language();
		lang.name = Language.DE;
		return lang;
	}

}
}