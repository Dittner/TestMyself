package de.dittner.testmyself.ui.view.map {
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.model.AppModel;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;
import de.dittner.testmyself.model.domain.vocabulary.VocabularyID;
import de.dittner.testmyself.model.domain.vocabulary.VocabularyInfo;
import de.dittner.testmyself.ui.common.view.ViewInfo;
import de.dittner.testmyself.ui.common.view.ViewModel;
import de.dittner.testmyself.utils.HashList;

import flash.events.Event;

public class MapVM extends ViewModel {
	public function MapVM() {
		super();
	}

	[Inject]
	public var appModel:AppModel;

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

	override protected function activate():void {}

	override public function viewActivated(info:ViewInfo):void {
		super.viewActivated(info);
		var op:IAsyncOperation;
		var vocabularyList:HashList = appModel.selectedLanguage.vocabularyHash;
		if (vocabularyList.has(VocabularyID.DE_WORD)) {
			op = (vocabularyList.read(VocabularyID.DE_WORD) as Vocabulary).loadInfo();
			op.addCompleteCallback(wordVocabularyInfoLoaded)
		}

		if (vocabularyList.has(VocabularyID.DE_VERB)) {
			op = (vocabularyList.read(VocabularyID.DE_VERB) as Vocabulary).loadInfo();
			op.addCompleteCallback(verbVocabularyInfoLoaded)
		}

		if (vocabularyList.has(VocabularyID.DE_LESSON)) {
			op = (vocabularyList.read(VocabularyID.DE_LESSON) as Vocabulary).loadInfo();
			op.addCompleteCallback(lessonVocabularyInfoLoaded)
		}
	}

	private function wordVocabularyInfoLoaded(op:IAsyncOperation):void {
		wordVocabularyInfo = op.result;
	}

	private function verbVocabularyInfoLoaded(op:IAsyncOperation):void {
		verbVocabularyInfo = op.result;
	}

	private function lessonVocabularyInfoLoaded(op:IAsyncOperation):void {
		lessonVocabularyInfo = op.result;
	}

	override protected function deactivate():void {}
}
}