package de.dittner.testmyself.ui.common.view {
import de.dittner.testmyself.ui.view.map.MapVM;
import de.dittner.testmyself.ui.view.noteList.NoteListVM;
import de.dittner.testmyself.ui.view.search.SearchVM;
import de.dittner.testmyself.ui.view.settings.SettingsVM;
import de.dittner.testmyself.ui.view.test.TestScreenMediator;

public class ScreenMediatorFactory extends SFProxy implements IScreenMediatorFactory {

	public function ScreenMediatorFactory():void {}

	private var wordMediator:SFMediator = new NoteListVM();
	private var verbMediator:SFMediator = new VerbScreenMediator();
	private var lessonMediator:SFMediator = new LessonScreenMediator();
	private var testMediator:SFMediator = new TestScreenMediator();
	private var searchMediator:SFMediator = new SearchVM();

	public function createScreenMediator(screenID:String):SFMediator {
		var mediator:SFMediator;
		switch (screenID) {
			case ViewID.ABOUT :
				mediator = new MapVM();
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
				mediator = new SettingsVM();
				break;
			default :
				throw new Error("Unknown screen ID:" + screenID);
		}
		return mediator;
	}

}
}
