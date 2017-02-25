package de.dittner.testmyself.ui.view.langList {
import de.dittner.async.IAsyncOperation;
import de.dittner.testmyself.backend.LocalStorage;
import de.dittner.testmyself.backend.LocalStorageKey;
import de.dittner.testmyself.logging.CLog;
import de.dittner.testmyself.logging.LogTag;
import de.dittner.testmyself.model.domain.language.LanguageID;
import de.dittner.testmyself.model.domain.vocabulary.Vocabulary;
import de.dittner.testmyself.model.domain.vocabulary.VocabularyID;
import de.dittner.testmyself.model.domain.vocabulary.VocabularyInfo;
import de.dittner.testmyself.ui.common.menu.MenuID;
import de.dittner.testmyself.ui.common.view.ViewModel;
import de.dittner.testmyself.utils.HashList;

import flash.events.Event;

import mx.resources.ResourceManager;

public class LangListVM extends ViewModel {
	public function LangListVM() {
		super();
	}

	//----------------------------------------------------------------------------------------------
	//
	//  DE
	//
	//----------------------------------------------------------------------------------------------

	//--------------------------------------
	//  deWordVocabularyInfo
	//--------------------------------------
	private var _deWordVocabularyInfo:VocabularyInfo;
	[Bindable("deWordVocabularyInfoChanged")]
	public function get deWordVocabularyInfo():VocabularyInfo {return _deWordVocabularyInfo;}
	public function set deWordVocabularyInfo(value:VocabularyInfo):void {
		if (_deWordVocabularyInfo != value) {
			_deWordVocabularyInfo = value;
			dispatchEvent(new Event("deWordVocabularyInfoChanged"));
		}
	}

	//--------------------------------------
	//  deVerbVocabularyInfo
	//--------------------------------------
	private var _deVerbVocabularyInfo:VocabularyInfo;
	[Bindable("deVerbVocabularyInfoChanged")]
	public function get deVerbVocabularyInfo():VocabularyInfo {return _deVerbVocabularyInfo;}
	public function set deVerbVocabularyInfo(value:VocabularyInfo):void {
		if (_deVerbVocabularyInfo != value) {
			_deVerbVocabularyInfo = value;
			dispatchEvent(new Event("deVerbVocabularyInfoChanged"));
		}
	}

	//--------------------------------------
	//  deLessonVocabularyInfo
	//--------------------------------------
	private var _deLessonVocabularyInfo:VocabularyInfo;
	[Bindable("deLessonVocabularyInfoChanged")]
	public function get deLessonVocabularyInfo():VocabularyInfo {return _deLessonVocabularyInfo;}
	public function set deLessonVocabularyInfo(value:VocabularyInfo):void {
		if (_deLessonVocabularyInfo != value) {
			_deLessonVocabularyInfo = value;
			dispatchEvent(new Event("deLessonVocabularyInfoChanged"));
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  EN
	//
	//----------------------------------------------------------------------------------------------

	//--------------------------------------
	//  enWordVocabularyInfo
	//--------------------------------------
	private var _enWordVocabularyInfo:VocabularyInfo;
	[Bindable("enWordVocabularyInfoChanged")]
	public function get enWordVocabularyInfo():VocabularyInfo {return _enWordVocabularyInfo;}
	public function set enWordVocabularyInfo(value:VocabularyInfo):void {
		if (_enWordVocabularyInfo != value) {
			_enWordVocabularyInfo = value;
			dispatchEvent(new Event("enWordVocabularyInfoChanged"));
		}
	}

	//--------------------------------------
	//  enVerbVocabularyInfo
	//--------------------------------------
	private var _enVerbVocabularyInfo:VocabularyInfo;
	[Bindable("enVerbVocabularyInfoChanged")]
	public function get enVerbVocabularyInfo():VocabularyInfo {return _enVerbVocabularyInfo;}
	public function set enVerbVocabularyInfo(value:VocabularyInfo):void {
		if (_enVerbVocabularyInfo != value) {
			_enVerbVocabularyInfo = value;
			dispatchEvent(new Event("enVerbVocabularyInfoChanged"));
		}
	}

	//--------------------------------------
	//  enLessonVocabularyInfo
	//--------------------------------------
	private var _enLessonVocabularyInfo:VocabularyInfo;
	[Bindable("enLessonVocabularyInfoChanged")]
	public function get enLessonVocabularyInfo():VocabularyInfo {return _enLessonVocabularyInfo;}
	public function set enLessonVocabularyInfo(value:VocabularyInfo):void {
		if (_enLessonVocabularyInfo != value) {
			_enLessonVocabularyInfo = value;
			dispatchEvent(new Event("enLessonVocabularyInfoChanged"));
		}
	}

	//----------------------------------------------------------------------------------------------
	//
	//  Methods
	//
	//----------------------------------------------------------------------------------------------

	override protected function activate():void {}

	override public function viewActivated(viewID:String):void {
		super.viewActivated(viewID);
		var op:IAsyncOperation;
		var enLangVocabularyHash:HashList = appModel.enLang.vocabularyHash;
		var deLangVocabularyHash:HashList = appModel.deLang.vocabularyHash;

		if (deLangVocabularyHash.has(VocabularyID.DE_WORD)) {
			op = (deLangVocabularyHash.read(VocabularyID.DE_WORD) as Vocabulary).loadInfo();
			op.addCompleteCallback(function (op:IAsyncOperation):void {
				deWordVocabularyInfo = op.isSuccess ? op.result : null;
			});
		}

		if (deLangVocabularyHash.has(VocabularyID.DE_VERB)) {
			op = (deLangVocabularyHash.read(VocabularyID.DE_VERB) as Vocabulary).loadInfo();
			op.addCompleteCallback(function (op:IAsyncOperation):void {
				deVerbVocabularyInfo = op.isSuccess ? op.result : null;
			});
		}

		if (deLangVocabularyHash.has(VocabularyID.DE_LESSON)) {
			op = (deLangVocabularyHash.read(VocabularyID.DE_LESSON) as Vocabulary).loadInfo();
			op.addCompleteCallback(function (op:IAsyncOperation):void {
				deLessonVocabularyInfo = op.isSuccess ? op.result : null;
			});
		}

		if (enLangVocabularyHash.has(VocabularyID.EN_WORD)) {
			op = (enLangVocabularyHash.read(VocabularyID.EN_WORD) as Vocabulary).loadInfo();
			op.addCompleteCallback(function (op:IAsyncOperation):void {
				enWordVocabularyInfo = op.isSuccess ? op.result : null;
			});
		}

		if (enLangVocabularyHash.has(VocabularyID.EN_VERB)) {
			op = (enLangVocabularyHash.read(VocabularyID.EN_VERB) as Vocabulary).loadInfo();
			op.addCompleteCallback(function (op:IAsyncOperation):void {
				enVerbVocabularyInfo = op.isSuccess ? op.result : null;
			});
		}

		if (enLangVocabularyHash.has(VocabularyID.EN_LESSON)) {
			op = (enLangVocabularyHash.read(VocabularyID.EN_LESSON) as Vocabulary).loadInfo();
			op.addCompleteCallback(function (op:IAsyncOperation):void {
				enLessonVocabularyInfo = op.isSuccess ? op.result : null;
			})
		}
	}

	public function selectLang(langID:uint):void {
		switch (langID) {
			case LanguageID.EN :
				ResourceManager.getInstance().localeChain = ["en_US"];
				appModel.selectedLanguage = appModel.enLang;
				LocalStorage.write(LocalStorageKey.SELECTED_LANG, "en_US");
				break;
			case LanguageID.DE :
				ResourceManager.getInstance().localeChain = ["de_DE"];
				LocalStorage.write(LocalStorageKey.SELECTED_LANG, "de_DE");
				appModel.selectedLanguage = appModel.deLang;
				break;
			default :
				CLog.err(LogTag.SYSTEM, "Unknown LangID: " + langID);
		}
		if (appModel.selectedLanguage)
			mainVM.viewNavigator.selectedViewID = MenuID.WORD;
	}

	override protected function deactivate():void {}
}
}