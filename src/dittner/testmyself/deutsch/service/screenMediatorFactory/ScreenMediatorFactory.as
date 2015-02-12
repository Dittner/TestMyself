package dittner.testmyself.deutsch.service.screenMediatorFactory {
import dittner.satelliteFlight.mediator.SFMediator;
import dittner.satelliteFlight.proxy.SFProxy;
import dittner.testmyself.deutsch.service.screenFactory.*;
import dittner.testmyself.deutsch.view.about.AboutScreenMediator;
import dittner.testmyself.deutsch.view.dictionary.lesson.LessonScreenMediator;
import dittner.testmyself.deutsch.view.dictionary.phrase.PhraseScreenMediator;
import dittner.testmyself.deutsch.view.dictionary.verb.VerbScreenMediator;
import dittner.testmyself.deutsch.view.dictionary.word.WordScreenMediator;
import dittner.testmyself.deutsch.view.search.SearchScreenMediator;
import dittner.testmyself.deutsch.view.settings.SettingsScreenMediator;
import dittner.testmyself.deutsch.view.test.TestScreenMediator;

public class ScreenMediatorFactory extends SFProxy implements IScreenMediatorFactory {

	public function ScreenMediatorFactory():void {}

	private var phraseMediator:SFMediator = new PhraseScreenMediator();
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
			case ScreenID.PHRASE :
				mediator = phraseMediator;
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
