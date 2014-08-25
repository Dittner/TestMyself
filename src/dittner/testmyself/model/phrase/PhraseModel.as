package dittner.testmyself.model.phrase {
import dittner.testmyself.command.backend.utils.SQLFactory;
import dittner.testmyself.message.PhraseMsg;
import dittner.testmyself.model.AppConfig;
import dittner.testmyself.model.common.DataBaseInfo;
import dittner.testmyself.model.common.IPageInfo;
import dittner.testmyself.model.common.ITransUnit;
import dittner.testmyself.model.common.ITransUnitModel;

import mvcexpress.mvc.Proxy;

public class PhraseModel extends Proxy implements ITransUnitModel {

	public function PhraseModel():void {
		super();
	}

	//--------------------------------------
	//  dbName
	//--------------------------------------
	public function get dbName():String {return AppConfig.PHRASE_DB_NAME;}

	//--------------------------------------
	//  transUnitClass
	//--------------------------------------
	public function get transUnitClass():Class {return Phrase;}

	//--------------------------------------
	//  sqlFactory
	//--------------------------------------
	private var _sqlFactory:SQLFactory = new SQLFactory();
	public function get sqlFactory():SQLFactory {return _sqlFactory;}

	//--------------------------------------
	//  pageInfo
	//--------------------------------------
	private var _pageInfo:IPageInfo = null;
	public function get pageInfo():IPageInfo {return _pageInfo;}
	public function set pageInfo(value:IPageInfo):void {
		_pageInfo = value;
		sendMessage(PhraseMsg.PAGE_INFO_CHANGED_NOTIFICATION, pageInfo);
	}

	//--------------------------------------
	//  themes
	//--------------------------------------
	private var _themes:Array;
	public function get themes():Array {return _themes;}
	public function set themes(value:Array):void {
		if (_themes != value) {
			_themes = value;
			sendMessage(PhraseMsg.THEMES_CHANGED_NOTIFICATION, themes);
		}
	}

	//--------------------------------------
	//  dataBaseInfo
	//--------------------------------------
	private var _dataBaseInfo:DataBaseInfo;
	public function get dataBaseInfo():DataBaseInfo {return _dataBaseInfo;}
	public function set dataBaseInfo(value:DataBaseInfo):void {
		if (_dataBaseInfo != value) {
			_dataBaseInfo = value;
			sendMessage(PhraseMsg.DB_INFO_CHANGED_NOTIFICATION, dataBaseInfo);
		}
	}

	//--------------------------------------
	//  selectedPhrase
	//--------------------------------------
	public function get selectedTransUnit():ITransUnit {return pageInfo ? pageInfo.selectedTransUnit : null;}
	public function set selectedTransUnit(value:ITransUnit):void {
		if (pageInfo && pageInfo.selectedTransUnit != value) {
			pageInfo.selectedTransUnit = value;
			sendMessage(PhraseMsg.PHRASE_SELECTED_NOTIFICATION, selectedTransUnit);
		}
	}

	//--------------------------------------
	//  filter
	//--------------------------------------
	private var _filter:Array = [];
	public function get filter():Array {return _filter;}
	public function set filter(value:Array):void {
		if (_filter != value) {
			_filter = value;
		}
	}

}
}
