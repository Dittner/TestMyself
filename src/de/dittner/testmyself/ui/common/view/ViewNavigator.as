package de.dittner.testmyself.ui.common.view {
import de.dittner.testmyself.ui.common.menu.MenuID;
import de.dittner.testmyself.ui.view.langList.LangListView;
import de.dittner.testmyself.ui.view.main.MainView;
import de.dittner.testmyself.ui.view.map.MapView;
import de.dittner.testmyself.ui.view.noteList.LessonView;
import de.dittner.testmyself.ui.view.noteList.NoteListView;
import de.dittner.testmyself.ui.view.search.SearchView;
import de.dittner.testmyself.ui.view.settings.SettingsView;
import de.dittner.testmyself.ui.view.test.TestView;
import de.dittner.walter.WalterProxy;
import de.dittner.walter.walter_namespace;

import flash.events.Event;

use namespace walter_namespace;

public class ViewNavigator extends WalterProxy {
	public static const SELECTED_VIEW_CHANGED_MSG:String = "selectedViewChangedMsg";
	public function ViewNavigator(mainView:MainView) {
		super();
		this.mainView = mainView;
	}

	private var mainView:MainView;

	//--------------------------------------
	//  selectedView
	//--------------------------------------
	private var _selectedView:ViewBase;
	[Bindable("selectedViewChanged")]
	public function get selectedView():ViewBase {return _selectedView;}
	private function setSelectedView(value:ViewBase):void {
		if (_selectedView != value) {
			_selectedView = value;
			dispatchEvent(new Event("selectedViewChanged"));
		}
	}

	//--------------------------------------
	//  selectedViewID
	//--------------------------------------
	private var _selectedViewID:String;
	[Bindable("selectedViewMenuChanged")]
	public function get selectedViewID():String {return _selectedViewID;}
	public function set selectedViewID(value:String):void {
		if (_selectedViewID != value) {
			_selectedViewID = value;
			navigate(selectedViewID);
			dispatchEvent(new Event("selectedViewMenuChanged"));
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	private function navigate(viewID:String):void {
		if (selectedView && selectedView.viewID == viewID) return;

		if (_selectedView) _selectedView.invalidate(NavigationPhase.VIEW_REMOVE);

		setSelectedView(createView(viewID));
		selectedView.invalidate(NavigationPhase.VIEW_ACTIVATE);

		sendMessage(SELECTED_VIEW_CHANGED_MSG, selectedView);
	}

	private static var langListView:LangListView = new LangListView();
	private static var mapView:MapView = new MapView();
	private static var noteListView:NoteListView = new NoteListView();
	private static var lessonView:LessonView = new LessonView();
	private static var testView:TestView = new TestView();
	private static var searchView:SearchView = new SearchView();
	private function createView(viewID:String):ViewBase {
		var view:ViewBase;
		switch (viewID) {
			case MenuID.LANG_LIST :
				view = langListView;
				break;
			case MenuID.MAP :
				view = mapView;
				break;
			case MenuID.WORD :
				view = noteListView;
				break;
			case MenuID.VERB :
				view = noteListView;
				break;
			case MenuID.LESSON :
				view = lessonView;
				break;
			case MenuID.TEST :
				view = testView;
				break;
			case MenuID.SEARCH :
				view = searchView;
				break;
			case MenuID.SETTINGS :
				view = new SettingsView();
				break;
			default :
				throw new Error("Unknown screen ID:" + viewID);
		}

		view.mainView = mainView;
		view.viewID = viewID;
		return view;
	}

	override protected function activate():void {}

	override protected function deactivate():void {}

}
}