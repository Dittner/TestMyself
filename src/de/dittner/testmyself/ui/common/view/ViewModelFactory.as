package de.dittner.testmyself.ui.common.view {
import de.dittner.testmyself.ui.view.main.MainVM;
import de.dittner.testmyself.ui.view.map.MapVM;
import de.dittner.testmyself.ui.view.noteList.NoteListVM;
import de.dittner.testmyself.ui.view.search.SearchVM;
import de.dittner.testmyself.ui.view.settings.SettingsVM;
import de.dittner.walter.WalterProxy;

public class ViewModelFactory extends WalterProxy {
	public static var instance:ViewModelFactory;

	public function ViewModelFactory() {
		super();
		if (instance) throw  new Error("ViewFactory must be Singleton!");
		instance = this;
	}

	[Inject]
	public var mainVM:MainVM;
	[Inject]
	public var mapVM:MapVM;
	[Inject]
	public var noteListVM:NoteListVM;
	[Inject]
	public var searchVM:SearchVM;
	[Inject]
	public var settingsVM:SettingsVM;

}
}
