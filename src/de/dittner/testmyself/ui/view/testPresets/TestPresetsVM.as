package de.dittner.testmyself.ui.view.testPresets {
import de.dittner.testmyself.model.domain.tag.Tag;
import de.dittner.testmyself.ui.common.menu.ViewID;
import de.dittner.testmyself.ui.common.page.TestPage;
import de.dittner.testmyself.ui.common.view.ViewInfo;
import de.dittner.testmyself.ui.common.view.ViewModel;

import flash.events.Event;

public class TestPresetsVM extends ViewModel {
	public function TestPresetsVM() {
		super();
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

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
	}

	public function startTesting(taskComplexity:uint, tag:Tag):void {
		var info:ViewInfo = new ViewInfo();
		info.viewID = ViewID.TESTING;
		info.menuViewID = viewInfo.menuViewID;
		testPage.taskComplexity = taskComplexity;
		testPage.selectedTag = tag;
		navigateTo(info);
	}

	public function showStatistics(taskComplexity:uint, tag:Tag):void {
		var info:ViewInfo = new ViewInfo();
		info.viewID = ViewID.TEST_STATISTICS;
		info.menuViewID = viewInfo.menuViewID;
		testPage.number = 0;
		testPage.countAllNotes = true;
		testPage.taskComplexity = taskComplexity;
		testPage.selectedTag = tag;
		navigateTo(info);
	}

}
}