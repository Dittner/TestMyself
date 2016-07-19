package de.dittner.testmyself.ui.common.view {
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

	public function createScreenMediator(screenID:String):SFMediator {
		var mediator:SFMediator;
		switch (screenID) {
			case ViewID.ABOUT :
				mediator = new AboutScreenMediator();
				break;
			case ViewID.WORD :
				mediator = wordMediator;
				break;
			case ViewID.VERB :
				mediator = verbMediator;
				break;
			case ViewID.LESSON :
				mediator = lessonMediator;
				break;
			case ViewID.TEST :
				mediator = testMediator;
				break;
			case ViewID.SEARCH :
				mediator = searchMediator;
				break;
			case ViewID.SETTINGS :
				mediator = new SettingsScreenMediator();
				break;
			default :
				throw new Error("Unknown screen ID:" + screenID);
		}
		return mediator;
	}

}
}
