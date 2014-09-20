package dittner.testmyself.deutsch.service.screenMediatorFactory {
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.proxy.SFProxy;
import dittner.testmyself.deutsch.service.screenFactory.*;
import dittner.testmyself.deutsch.view.about.AboutScreenMediator;
import dittner.testmyself.deutsch.view.note.PhraseScreenMediator;
import dittner.testmyself.deutsch.view.note.VerbScreenMediator;
import dittner.testmyself.deutsch.view.note.WordScreenMediator;
import dittner.testmyself.deutsch.view.settings.SettingsScreenMediator;
import dittner.testmyself.deutsch.view.template.TemplateScreenMediator;
import dittner.testmyself.deutsch.view.test.TestScreenMediator;

public class ScreenMediatorFactory extends SFProxy implements IScreenMediatorFactory {

	public function ScreenMediatorFactory():void {}

	private var phraseMediator:SFMediator = new PhraseScreenMediator();
	private var wordMediator:SFMediator = new WordScreenMediator();
	private var verbMediator:SFMediator = new VerbScreenMediator();
	private var testMediator:SFMediator = new TestScreenMediator();

	public function createScreenMediator(screenId:String):SFMediator {
		var mediator:SFMediator;
		switch (screenId) {
			case ScreenID.ABOUT :
				mediator = new AboutScreenMediator();
				break;
			case ScreenID.WORD :
				mediator = wordMediator;
				break;
			case ScreenID.PHRASE :
				mediator = phraseMediator;
				break;
			case ScreenID.VERB :
				mediator = verbMediator;
				break;
			case ScreenID.TEST :
				mediator = testMediator;
				break;
			case ScreenID.SEARCH :
				mediator = new TemplateScreenMediator();
				break;
			case ScreenID.SETTINGS :
				mediator = new SettingsScreenMediator();
				break;
			default :
				throw new Error("Unknown screen ID:" + screenId);
		}
		return mediator;
	}

}
}
