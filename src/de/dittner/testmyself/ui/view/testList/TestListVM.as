package de.dittner.testmyself.ui.view.testList {
import de.dittner.testmyself.model.domain.test.Test;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;
import de.dittner.testmyself.ui.common.menu.ViewID;
import de.dittner.testmyself.ui.common.page.TestPage;
import de.dittner.testmyself.ui.common.view.ViewInfo;
import de.dittner.testmyself.ui.common.view.ViewModel;

import flash.events.Event;

import mx.collections.ArrayCollection;

public class TestListVM extends ViewModel {
	public function TestListVM() {
		super();
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Properties
	//
	//----------------------------------------------------------------------------------------------

	//--------------------------------------
	//  vocabularyColl
	//--------------------------------------
	private var _vocabularyColl:ArrayCollection;
	[Bindable("vocabularyCollChanged")]
	public function get vocabularyColl():ArrayCollection {return _vocabularyColl;}
	public function set vocabularyColl(value:ArrayCollection):void {
		if (_vocabularyColl != value) {
			_vocabularyColl = value;
			dispatchEvent(new Event("vocabularyCollChanged"));
		}
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
		testPage.loadOnlyFailedTestTask = true;
		testPage.selectedTag = null;
		vocabularyColl = new ArrayCollection(appModel.selectedLanguage.vocabularyHash.getList());
	}

	public function showTestPresets(voc:Vocabulary, test:Test):void {
		testPage.vocabulary = voc;
		testPage.test = test;

		var info:ViewInfo = new ViewInfo();
		info.viewID = ViewID.TEST_PRESETS;
		info.page = testPage;
		navigateTo(info);
	}

}
}