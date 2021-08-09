package de.dittner.testmyself.ui.view.info {
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;
import de.dittner.testmyself.model.domain.vocabulary.VocabularyID;
import de.dittner.testmyself.model.domain.vocabulary.VocabularyInfo;
import de.dittner.testmyself.ui.common.menu.MenuViewID;
import de.dittner.testmyself.ui.common.menu.ViewID;
import de.dittner.testmyself.ui.common.view.ViewInfo;
import de.dittner.testmyself.ui.common.view.ViewModel;
import de.dittner.testmyself.utils.HashList;

import flash.events.Event;

public class InfoVM extends ViewModel {
	public function InfoVM() {
		super();
	}

	//----------------------------------------------------------------------------------------------
	//
	//  DE
	//
	//----------------------------------------------------------------------------------------------

	//--------------------------------------
	//  wordVocabularyInfo
	//--------------------------------------
	private var _wordVocabularyInfo:VocabularyInfo;
	[Bindable("wordVocabularyInfoChanged")]
	public function get wordVocabularyInfo():VocabularyInfo {return _wordVocabularyInfo;}
	public function set wordVocabularyInfo(value:VocabularyInfo):void {
		if (_wordVocabularyInfo != value) {
			_wordVocabularyInfo = value;
			dispatchEvent(new Event("wordVocabularyInfoChanged"));
		}
	}

	//--------------------------------------
	//  verbVocabularyInfo
	//--------------------------------------
	private var _verbVocabularyInfo:VocabularyInfo;
	[Bindable("verbVocabularyInfoChanged")]
	public function get verbVocabularyInfo():VocabularyInfo {return _verbVocabularyInfo;}
	public function set verbVocabularyInfo(value:VocabularyInfo):void {
		if (_verbVocabularyInfo != value) {
			_verbVocabularyInfo = value;
			dispatchEvent(new Event("verbVocabularyInfoChanged"));
		}
	}

	//--------------------------------------
	//  lessonVocabularyInfo
	//--------------------------------------
	private var _lessonVocabularyInfo:VocabularyInfo;
	[Bindable("lessonVocabularyInfoChanged")]
	public function get lessonVocabularyInfo():VocabularyInfo {return _lessonVocabularyInfo;}
	public function set lessonVocabularyInfo(value:VocabularyInfo):void {
		if (_lessonVocabularyInfo != value) {
			_lessonVocabularyInfo = value;
			dispatchEvent(new Event("lessonVocabularyInfoChanged"));
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override protected function activate():void {}

	override public function viewActivated(viewInfo:ViewInfo):void {
		super.viewActivated(viewInfo);
		var op:IAsyncOperation;
		var vocabularyHash:HashList = appModel.lang.vocabularyHash;

		if (vocabularyHash.has(VocabularyID.DE_WORD)) {
			op = (vocabularyHash.read(VocabularyID.DE_WORD) as Vocabulary).loadInfo();
			op.addCompleteCallback(function (op:IAsyncOperation):void {
				wordVocabularyInfo = op.isSuccess ? op.result : null;
			});
		}

		if (vocabularyHash.has(VocabularyID.DE_VERB)) {
			op = (vocabularyHash.read(VocabularyID.DE_VERB) as Vocabulary).loadInfo();
			op.addCompleteCallback(function (op:IAsyncOperation):void {
				verbVocabularyInfo = op.isSuccess ? op.result : null;
			});
		}

		if (vocabularyHash.has(VocabularyID.DE_LESSON)) {
			op = (vocabularyHash.read(VocabularyID.DE_LESSON) as Vocabulary).loadInfo();
			op.addCompleteCallback(function (op:IAsyncOperation):void {
				lessonVocabularyInfo = op.isSuccess ? op.result : null;
			});
		}

		if (vocabularyHash.has(VocabularyID.EN_WORD)) {
			op = (vocabularyHash.read(VocabularyID.EN_WORD) as Vocabulary).loadInfo();
			op.addCompleteCallback(function (op:IAsyncOperation):void {
				wordVocabularyInfo = op.isSuccess ? op.result : null;
			});
		}

		if (vocabularyHash.has(VocabularyID.EN_VERB)) {
			op = (vocabularyHash.read(VocabularyID.EN_VERB) as Vocabulary).loadInfo();
			op.addCompleteCallback(function (op:IAsyncOperation):void {
				verbVocabularyInfo = op.isSuccess ? op.result : null;
			});
		}

		if (vocabularyHash.has(VocabularyID.EN_LESSON)) {
			op = (vocabularyHash.read(VocabularyID.EN_LESSON) as Vocabulary).loadInfo();
			op.addCompleteCallback(function (op:IAsyncOperation):void {
				lessonVocabularyInfo = op.isSuccess ? op.result : null;
			})
		}
	}

	public function navigateToWordList():void {
		var info:ViewInfo = new ViewInfo();
		info.viewID = ViewID.WORD_LIST;
		info.menuViewID = MenuViewID.WORD;
		mainVM.viewNavigator.clearViewStack();
		mainVM.viewNavigator.navigate(info);
	}

	override protected function deactivate():void {}
}
}