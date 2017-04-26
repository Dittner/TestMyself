package de.dittner.testmyself.ui.view.testStatistics {
import de.dittner.testmyself.ui.common.menu.ViewID;
import de.dittner.testmyself.ui.common.page.TestPage;
import de.dittner.testmyself.ui.common.view.ViewInfo;
import de.dittner.testmyself.ui.common.view.ViewModel;

import flash.events.Event;

public class TestStatisticsVM extends ViewModel {
	public function TestStatisticsVM() {
		super();
	}

	//--------------------------------------
	//  testPage
	//--------------------------------------
	private var _testPage:TestPage;
	[Bindable("testPageChanged")]
	public function get testPage():TestPage {return _testPage;}
	private function setTestPage(value:TestPage):void {
		if (_testPage != value) {
			_testPage = value;
			dispatchEvent(new Event("testPageChanged"));
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override public function viewActivated(viewInfo:ViewInfo):void {
		super.viewActivated(viewInfo);
		setTestPage(appModel.getTestPage());
		reloadPage();
	}

	public function updateTestTaskList(showOnlyFailed:Boolean):void {
		if (testPage.loadOnlyFailedTestTask != showOnlyFailed) {
			testPage.loadOnlyFailedTestTask = showOnlyFailed;
			testPage.number = 0;
			testPage.countAllNotes = true;
			reloadPage();
		}
	}

	public function reloadPage():void {
		if (testPage) testPage.load();
	}

	public function showTestTask(taskIndex:int):void {
		if (testPage) {
			var info:ViewInfo = new ViewInfo();
			info.viewID = ViewID.NOTE_VIEW;
			info.page = testPage;
			info.page.selectedItemIndex = taskIndex != -1 ? taskIndex : 0;
			mainVM.viewNavigator.navigate(info);
		}
	}
}
}