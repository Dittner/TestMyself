package dittner.testmyself.deutsch.service.screenMediatorFactory {
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.proxy.SFProxy;
import dittner.testmyself.deutsch.service.screenFactory.*;
import dittner.testmyself.deutsch.view.about.AboutScreenMediator;
import dittner.testmyself.deutsch.view.note.NoteScreenMediator;
import dittner.testmyself.deutsch.view.settings.SettingsScreenMediator;
import dittner.testmyself.deutsch.view.template.TemplateScreenMediator;

public class ScreenMediatorFactory extends SFProxy implements IScreenMediatorFactory {

	public function ScreenMediatorFactory():void {}

	private var phraseMediator:SFMediator = new NoteScreenMediator();
	private var wordMediator:SFMediator = new NoteScreenMediator();

	public function createScreenMediator(screenId:String):SFMediator {
		var mediator:SFMediator;
		switch (screenId) {
			case ScreenId.ABOUT :
				mediator = new AboutScreenMediator();
				break;
			case ScreenId.WORD :
				mediator = wordMediator;
				break;
			case ScreenId.PHRASE :
				mediator = phraseMediator;
				break;
			case ScreenId.VERB :
				mediator = new TemplateScreenMediator();
				break;
			case ScreenId.TEST :
				mediator = new TemplateScreenMediator();
				break;
			case ScreenId.SEARCH :
				mediator = new TemplateScreenMediator();
				break;
			case ScreenId.SETTINGS :
				mediator = new SettingsScreenMediator();
				break;
			default :
				throw new Error("Unknown screen ID:" + screenId);
		}
		return mediator;
	}

}
}
