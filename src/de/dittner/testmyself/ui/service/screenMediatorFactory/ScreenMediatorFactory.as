package de.dittner.testmyself.ui.service.screenMediatorFactory {
import de.dittner.satelliteFlight.mediator.SFMediator;
import de.dittner.satelliteFlight.proxy.SFProxy;
import de.dittner.testmyself.ui.service.screenFactory.ScreenID;
import de.dittner.testmyself.ui.view.about.AboutScreenMediator;
import de.dittner.testmyself.ui.view.dictionary.lesson.LessonScreenMediator;
import de.dittner.testmyself.ui.view.dictionary.verb.VerbScreenMediator;
import de.dittner.testmyself.ui.view.dictionary.word.WordScreenMediator;
import de.dittner.testmyself.ui.view.search.SearchScreenMediator;
import de.dittner.testmyself.ui.view.settings.SettingsScreenMediator;
import de.dittner.testmyself.ui.view.test.TestScreenMediator;

public class ScreenMediatorFactory extends SFProxy implements IScreenMediatorFactory {

	public function ScreenMediatorFactory():void {}

	private var wordMediator:SFMediator = new WordScreenMediator();
	private var verbMediator:SFMediator = new VerbScreenMediator();
	private var lessonMediator:SFMediator = new LessonScreenMediator();
	private var testMediator:SFMediator = new TestScreenMediator();
	private var searchMediator:SFMediator = new SearchScreenMediator();

	public function createScreenMediator(screenId:String):SFMediator {
		var mediator:SFMediator;
		switch (screenId) {
			case ScreenID.ABOUT :
				mediator = new AboutScreenMediator();
				break;
			case ScreenID.WORD :
				mediator = wordMediator;
				break;
			case ScreenID.VERB :
				mediator = verbMediator;
				break;
			case ScreenID.LESSON :
				mediator = lessonMediator;
				break;
			case ScreenID.TEST :
				mediator = testMediator;
				break;
			case ScreenID.SEARCH :
				mediator = searchMediator;
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
