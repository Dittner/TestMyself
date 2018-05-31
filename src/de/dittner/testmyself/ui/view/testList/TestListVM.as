package de.dittner.testmyself.ui.view.testList {
import de.dittner.testmyself.model.domain.language.LanguageID;
import de.dittner.testmyself.model.domain.test.Test;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;
import de.dittner.testmyself.model.domain.vocabulary.VocabularyID;
import de.dittner.testmyself.ui.common.menu.ViewID;
import de.dittner.testmyself.ui.common.page.TestPage;
import de.dittner.testmyself.ui.common.view.ViewInfo;
import de.dittner.testmyself.ui.common.view.ViewModel;
import de.dittner.testmyself.utils.HashList;

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
	//  wordVocabularyTestColl
	//--------------------------------------
	private var _wordVocabularyTestColl:ArrayCollection;
	[Bindable("wordVocabularyTestCollChanged")]
	public function get wordVocabularyTestColl():ArrayCollection {return _wordVocabularyTestColl;}
	public function set wordVocabularyTestColl(value:ArrayCollection):void {
		if (_wordVocabularyTestColl != value) {
			_wordVocabularyTestColl = value;
			dispatchEvent(new Event("wordVocabularyTestCollChanged"));
		}
	}

	//--------------------------------------
	//  verbVocabularyTestColl
	//--------------------------------------
	private var _verbVocabularyTestColl:ArrayCollection;
	[Bindable("verbVocabularyTestCollChanged")]
	public function get verbVocabularyTestColl():ArrayCollection {return _verbVocabularyTestColl;}
	public function set verbVocabularyTestColl(value:ArrayCollection):void {
		if (_verbVocabularyTestColl != value) {
			_verbVocabularyTestColl = value;
			dispatchEvent(new Event("verbVocabularyTestCollChanged"));
		}
	}

	//--------------------------------------
	//  lessonVocabularyTestColl
	//--------------------------------------
	private var _lessonVocabularyTestColl:ArrayCollection;
	[Bindable("lessonVocabularyTestCollChanged")]
	public function get lessonVocabularyTestColl():ArrayCollection {return _lessonVocabularyTestColl;}
	public function set lessonVocabularyTestColl(value:ArrayCollection):void {
		if (_lessonVocabularyTestColl != value) {
			_lessonVocabularyTestColl = value;
			dispatchEvent(new Event("lessonVocabularyTestCollChanged"));
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
		var vocHash:HashList = appModel.lang.vocabularyHash;

		if (appModel.lang.id == LanguageID.DE) {
			wordVocabularyTestColl = new ArrayCollection( (vocHash.read(VocabularyID.DE_WORD) as Vocabulary).availableTests);
			verbVocabularyTestColl = new ArrayCollection( (vocHash.read(VocabularyID.DE_VERB) as Vocabulary).availableTests);
			lessonVocabularyTestColl = new ArrayCollection( (vocHash.read(VocabularyID.DE_LESSON) as Vocabulary).availableTests);
		}
		else if (appModel.lang.id == LanguageID.EN) {
			wordVocabularyTestColl = new ArrayCollection( (vocHash.read(VocabularyID.EN_WORD) as Vocabulary).availableTests);
			verbVocabularyTestColl = new ArrayCollection( (vocHash.read(VocabularyID.EN_VERB) as Vocabulary).availableTests);
			lessonVocabularyTestColl = new ArrayCollection( (vocHash.read(VocabularyID.EN_LESSON) as Vocabulary).availableTests);
		}
		else {
			wordVocabularyTestColl = null;
			verbVocabularyTestColl = null;
			lessonVocabularyTestColl = null;
		}
	}

	public function showTestPresets(test:Test):void {
		testPage.vocabulary = test.vocabulary;
		testPage.test = test;

		var info:ViewInfo = new ViewInfo();
		info.viewID = ViewID.TEST_PRESETS;
		info.page = testPage;
		navigateTo(info);
	}

}
}