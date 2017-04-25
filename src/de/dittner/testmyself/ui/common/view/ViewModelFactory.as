package de.dittner.testmyself.ui.common.view {
import de.dittner.testmyself.ui.view.form.NoteFormVM;
import de.dittner.testmyself.ui.view.langList.LangListVM;
import de.dittner.testmyself.ui.view.lessonTagList.LessonTagListVM;
import de.dittner.testmyself.ui.view.main.MainVM;
import de.dittner.testmyself.ui.view.map.MapVM;
import de.dittner.testmyself.ui.view.noteList.NoteListVM;
import de.dittner.testmyself.ui.view.noteView.NoteViewVM;
import de.dittner.testmyself.ui.view.search.SearchVM;
import de.dittner.testmyself.ui.view.settings.SettingsVM;
import de.dittner.testmyself.ui.view.testList.TestListVM;
import de.dittner.testmyself.ui.view.testPresets.TestPresetsVM;
import de.dittner.testmyself.ui.view.testStatistics.TestStatisticsVM;
import de.dittner.testmyself.ui.view.testing.TestingVM;
import de.dittner.walter.WalterProxy;

public class ViewModelFactory extends WalterProxy {
	public static var instance:ViewModelFactory;

	public function ViewModelFactory() {
		super();
		if (instance) throw new Error("ViewFactory must be Singleton!");
		instance = this;
	}

	[Inject]
	public var mainVM:MainVM;
	[Inject]
	public var langListVM:LangListVM;
	[Inject]
	public var mapVM:MapVM;
	[Inject]
	public var testingVM:TestingVM;
	[Inject]
	public var testStatisticsVM:TestStatisticsVM;
	[Inject]
	public var testPresetsVM:TestPresetsVM;
	[Inject]
	public var testListVM:TestListVM;
	[Inject]
	public var wordListVM:NoteListVM;
	[Inject]
	public var noteFormVM:NoteFormVM;
	[Inject]
	public var noteViewVM:NoteViewVM;
	[Inject]
	public var verbListVM:NoteListVM;
	[Inject]
	public var lessonListVM:NoteListVM;
	[Inject]
	public var lessonTagListVM:LessonTagListVM;
	[Inject]
	public var searchVM:SearchVM;
	[Inject]
	public var settingsVM:SettingsVM;

}
}
